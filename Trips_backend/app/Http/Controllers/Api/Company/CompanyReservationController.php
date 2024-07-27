<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\Company\CompanyReservationUserResource;
use App\Models\PaymentReservations;
use App\Models\Reservation;
use App\Models\Seat;
use App\Models\Trip;
use App\Models\User;
use App\Notifications\SendPushNotification;
use App\Rules\MatchingCountIdsWithPassengers;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Str;

class CompanyReservationController extends ApiController
{

    public function getReservationsByTripId($trip_id)
    {
        $company_id = auth('company')->user()->company_id;

        $trip = Trip::where('id', $trip_id)->where('company_id', $company_id)->first();
        if (!$trip) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'bad id');
        }
        $reservations = $trip->reservations;
        return $this->apiResponse(['reservations' => CompanyReservationUserResource::collection($reservations)]);
    }

    public function confirm_reservation($reservation_id)
    {
        $user_id = auth('company')->user()->company_id;
        $reservation = Reservation::where([['company_id', $user_id], ['id', $reservation_id]])->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong id');
        }
        foreach ($reservation->seats as $seat) {
            $seat->update([
                'status' => 'unavailable'
            ]);
        }
        $payment_reservation = PaymentReservations::create([
            'phone' => $reservation->phone,
            'company_id' => $user_id,
            'price' =>  count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100))),
            'is_temp_from_app' => true,
            'is_confirm_by_center' => true,
            'date' => $reservation->trip->start_date,
            'reservation_id' => $reservation->id,
        ]);

        $user = User::find($reservation->user_id);
        $startDateTime = Carbon::parse($reservation->trip->start_date);
        $data_notification = [
            'trip_id' => $reservation->trip->id,
        ];
        $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";

        $lang = app()->getLocale();
        $sourceCityName = $reservation->trip->source_city->getNameInLanguage($user->lang);
        $destinationCityName = $reservation->trip->destination_city->getNameInLanguage($user->lang);
        $now = Carbon::now();

        // Get date separated (Y-m-d)
        $dateSeparated = $startDateTime->toDateString();
        $date_trip =  Carbon::parse($reservation->trip->start_date)->toDateString();
        // Get time separated (H:i:s)
        $timeSeparated = $startDateTime->format('g:i a');
        $message_notification = $user->lang == 'ar' ? "تم تثبيت الحجز المؤقت للرحلة من $sourceCityName إلى $destinationCityName بتاريخ $date_trip الساعة $timeSeparated "
            : "The temporary reservation for the trip from " . $sourceCityName . " to " . $destinationCityName . " has been confirmed on " . $date_trip . " at " . $timeSeparated;
        $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_temporary'));


        return $this->apiResponse([], self::STATUS_OK, 'confirm reservation successfully');
    }

    public function reserve_seats(Request $request)
    {

        $ids = $request->input('ids');
        $passengers = $request->input('passengers');
        $differentName = $request->input('different_name');


        $validate = $this->apiValidation($request, [
            'ids' => [
                'required',
                'array',
                // $differentName ? new MatchingCountIdsWithPassengers($passengers)  : null
            ],
            'ids.*' => 'exists:seats,id',
            'full_name' => 'required',
            // 'passengers' => 'required|array',
            // 'passengers.*.name' => 'required',
            // 'passengers.*.age' => 'required',
        ]);

        if ($validate instanceof Response) return $validate;

        $user_id = auth('company')->user()->company_id;
        $seats = Seat::whereIn('id', $request->ids)->get();
        foreach ($seats as $seat) {
            if ($seat->status != 'available') {
                return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'there are seats unavailable');
            }
            $selectedDateTime = $seat->selected_date ? Carbon::parse($seat->selected_date) : false;
            if ($selectedDateTime) {
                $currentTime = Carbon::now();
                $currentTime = $currentTime->addHours(3);
                $differenceInMinutes = $currentTime->diffInMinutes($selectedDateTime);
                $is_selected =  $differenceInMinutes < 5;
                if ($is_selected && $seat->selected_user_id !== $user_id) {
                    return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'there are seats selected');
                }
            }
        }


        $reservation_id = Reservation::insertGetId([
            'trip_id' => $seats[0]['trip_id'],
            'user_id' => $user_id,
            'from_user' => false,
            'phone' => $request->phone,
            'unique_id' => random_int(1000000, 9999999),
            'company_id' => $user_id
        ]);
        $trip = Trip::find($seats[0]['trip_id']);
        $payment_reservation = PaymentReservations::create([
            'phone' => $request->phone,
            'company_id' => $user_id,
            'price' => $trip->ticket_price  * count($seats),
            'is_temp_from_app' => false,
            'is_confirm_by_center' => true,
            'date' => $trip->start_date,
            'reservation_id' => $reservation_id,
        ]);



        foreach ($seats as $index => $seat) {

            $seat->update([
                'status' => 'unavailable',
                'name' => $request->full_name,
                // 'age' =>$passengers[$index]['age'],
                // 'gender' =>$passengers[$index]['gender'],
                'reservation_id' => $reservation_id
            ]);
        }

        $trip->seats_leaft = $trip->seats_leaft - count($seats);
        $trip->save();
        return $this->apiResponse([], self::STATUS_OK, 'reservation successfully');
    }

    public function select_seats(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'id' => 'exists:seats,id',
        ]);


        if ($validate instanceof Response) return $validate;

        $seat = Seat::where('id', $request->id)->first();
        $user_id = auth('company')->user()->company_id;
        // foreach ($seats as $seat) {
        if ($seat->status != 'available') {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'there are seats unavailable');
        }
        $selectedDateTime = $seat->selected_date ? Carbon::parse($seat->selected_date) : false;

        if ($seat->is_selected && $selectedDateTime) {
            $currentTime = Carbon::now();
            $currentTime = $currentTime->addHours(3);
            $differenceInMinutes = $currentTime->diffInMinutes($selectedDateTime);
            $is_selected =  $differenceInMinutes < 5;
            if ($is_selected) {
                return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'there are seats selected');
            }
        }
        // }
        $currentTime = Carbon::now();
        $currentTime = $currentTime->addHours(3);
        broadcast(new \App\Events\SeatEvent($seat->number_seat, 'selected', $seat->trip_id, 'B'));

        $seat->update([
            'is_selected' => true,
            'selected_user_id' => $user_id,
            'selected_date' => $currentTime,
            'selected_by_user' => false,
        ]);


        return $this->apiResponse([], self::STATUS_OK, 'select seats successfully');
    }

    public function unselect_seats(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'id' => 'exists:seats,id',
        ]);


        if ($validate instanceof Response) return $validate;

        $user_id = auth('company')->user()->company_id;
        $seat = Seat::where('id', $request->id)->first();


        // $selectedDateTime = $seat->selected_date ? Carbon::parse($seat->selected_date) : false;

        // if ($seat->is_selected && $selectedDateTime) {
        //     $currentTime = Carbon::now();
        //     $currentTime = $currentTime->addHours(3);
        //     $differenceInMinutes = $currentTime->diffInMinutes($selectedDateTime);
        //     $is_selected =  $differenceInMinutes < 5;
        //     if ($is_selected) {
        //         return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'there are seats selected');
        //     }
        // }
        // }
        // $currentTime = Carbon::now();
        // $currentTime = $currentTime->addHours(3);
        broadcast(new \App\Events\SeatEvent($seat->number_seat, 'unselected', $seat->trip_id, 'B'));

        $seat->update([
            'is_selected' => false,
            // 'selected_user_id' => $user_id,
            // 'selected_date' => $currentTime,
            // 'selected_by_user' => true,
        ]);


        return $this->apiResponse([], self::STATUS_OK, 'unselect seats successfully');
    }
}
