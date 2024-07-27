<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\BookingResource;
use App\Http\Resources\ReservationResource;
use App\Http\services\gateways\SyriatelSms;
use App\Models\CancelReservation;
use App\Models\ConfirmReservationCode;
use App\Models\Parameter;
use App\Models\Payment;
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
use Illuminate\Support\Facades\Http;

class ReservationController extends ApiController
{
    public function myBooking()
    {
        $user = auth()->user();
        $reservations = Reservation::where('user_id', $user->id)->orderBy('id', 'desc')->get();
        $confirmed = [];
        $history = [];
        $temp = [];

        foreach ($reservations as $reservation) {
            if (count($reservation->seats) >0 && $reservation->trip->start_date < Carbon::now()->subHours(2)) {
                array_push($history, $reservation);
            } elseif (count($reservation->seats) >0 && $reservation->seats[0]->status == 'unavailable') {
                array_push($confirmed, $reservation);
            } else if (count($reservation->seats) >0 && $reservation->seats[0]->status == 'temporary') {
                array_push($temp, $reservation);
            }
        }
        return $this->apiResponse([
            'confirmed' => BookingResource::collection(collect($confirmed)),
            'temp' => BookingResource::collection(collect($temp)),
            'history' => BookingResource::collection(collect($history)),
        ], self::STATUS_OK, 'get booking successfully');
    }
    public function show(Request $request, $id)
    {
        $trip = Trip::findOrFail($id);
        return ReservationResource::collection($trip->reservations);
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
                $differentName ? new MatchingCountIdsWithPassengers($passengers)  : null
            ],
            'ids.*' => 'exists:seats,id',
            'passengers' => 'required|array',
            'passengers.*.name' => 'required',
            'passengers.*.age' => 'required',
        ]);

        if ($validate instanceof Response) return $validate;

        $user_id = auth()->user()->id;
        $seats = Seat::whereIn('id', $request->ids)->get();
        $trip_id = $seats[0]['trip_id'];

        if ($request->is_temp) {
            $check_if_reservation_temp_before = Reservation::where('user_id', $user_id)
                ->where('trip_id', $trip_id)->get();
            foreach ($check_if_reservation_temp_before as $reservation) {
                if ($reservation->seats[0]->status == 'temporary') {
                    return $this->apiResponse([], self::STATUS_FORBIDDEN, 'لديك حجز مؤقت على هذه الرحلة, الرجاء تثبيت الحجز الحالي لإتمام الحجز');
                }
            }
        }

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

        $currentYear = date("Y");
        $currentMonth = date("m");
        $random_number = random_int(1000000, 9999999);
        while (true) {
            $check = Reservation::whereYear('created_at', $currentYear)
                ->whereMonth('created_at', $currentMonth)->where('unique_id', $random_number)
                ->first();
            if ($check) {
                $random_number = random_int(1000000, 9999999);
            } else {
                break;
            }
        }
        $trip = Trip::find($trip_id);
        $reservation_id = Reservation::insertGetId([
            'trip_id' => $trip_id,
            'user_id' => $user_id,
            'phone' => auth()->user()->phone,
            'unique_id' => $random_number,
            'company_id' => $trip->company->id
        ]);
        $currentTime = Carbon::now();
        $currentTime = $currentTime->addHours(3);
        foreach ($seats as $index => $seat) {
            $seat->update([
                'status' => $request->is_temp ? 'temporary' : 'available',
                'name' => $passengers[$index]['name'],
                'age' => $passengers[$index]['age'],
                'gender' => $passengers[$index]['gender'],
                'phone' =>  $passengers[$index]['last_name'] ?? null,
                'is_selected' => true,
                'selected_user_id' => $user_id,
                'selected_date' => $currentTime,
                'reservation_id' => $reservation_id
            ]);
        }
        $trip = Trip::find($trip_id);
        if ($request->is_temp) {
            $trip->seats_leaft = $trip->seats_leaft - count($request->ids);
        }

        $trip->save();

        if (!$request->is_temp) {
            $user = auth()->user();
            $rateIds = json_decode($user->rate_ids, true);
            if ($rateIds === null) {
                $rateIds = [];
            }

            $rateIds[] = $trip_id;

            $user->rate_ids = json_encode($rateIds);
            /** @var \App\Models\User $user **/
            $user->save();
        }

        $params = Parameter::first();
        if ($request->is_temp) {
            $user = User::find($user_id);
            $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";
            $data_notification = [
                'trip_id' => $trip->id,
            ];
            $startDateTime = Carbon::parse($trip->start_date);
            $now = Carbon::now();

            if ($now->diffInDays($startDateTime, false) > 1) {
                // اليوم الحالي قبل الحدث بأكثر من يومين
                $entryDateTime = $startDateTime->subDays(2)->format('Y-m-d g:i a');
            } elseif ($now->isSameDay($startDateTime)) {
                // اليوم الحالي هو نفس يوم الحدث
                $entryDateTime = $now->copy()->addHour()->format('Y-m-d g:i a');
            } else {
                // اليوم الحالي قبل الحدث بيوم واحد
                $entryDateTime = $startDateTime->subDay()->format('Y-m-d g:i a');
            }
            $lang = app()->getLocale();
            $sourceCityName = $trip->source_city->getNameInLanguage($user->lang);
            $destinationCityName = $trip->destination_city->getNameInLanguage($user->lang);
            $now = Carbon::now();

            // Get date separated (Y-m-d)
            $dateSeparated = $startDateTime->toDateString();
            $date_trip =  Carbon::parse($trip->start_date)->toDateString();
            // Get time separated (H:i:s)
            $timeSeparated = $startDateTime->format('g:i a');
            $message_notification = $user->lang == 'ar' ? "تم تثبيت الحجز المؤقت للرحلة من $sourceCityName إلى $destinationCityName بتاريخ $date_trip الساعة $timeSeparated بشكل صحيح. يرجى تأكيد الحجز قبل $entryDateTime"
                : "The temporary reservation for the trip from " . $sourceCityName . " to " . $destinationCityName . " has been confirmed on " . $date_trip . " at " . $timeSeparated . ". Please confirm your reservation before " . $entryDateTime;
            $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_temporary'));
        } else {
            $user = User::find($user_id);
            $title = "رحلات";
            $data_notification = [
                'trip_id' => $trip->id,
            ];

            // $message_notification = ($user->lang == 'ar') ? $params->paid_reservation_confirmation : $params->paid_reservation_confirmation_en;
            // $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_confirmed'));
        }


        return $this->apiResponse(['reservation_id', $reservation_id], self::STATUS_OK, 'reservation successfully');
    }


    public function request_cancel_reservation($book_id)
    {
        $user = auth()->user();
        $get_code = ConfirmReservationCode::create([
            'code' => random_int(100000, 999999),
            'user_id' => $user->id,
            'reservation_id' => $book_id,
        ]);
        app(SyriatelSms::class)->sendSms($user->phone, $get_code->code);
        return $this->apiResponse([], self::STATUS_OK, 'successfully');
    }

    public function remove_reserve_temp(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'code' => 'required',
        ]);

        if ($validate instanceof Response) return $validate;

        $user_id = auth()->user()->id;
        $check_code = ConfirmReservationCode::where('user_id', $user_id)->where('code', $request->code)->latest()->first();
        if (!$check_code) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'the code is invalid');
        }
        $reservation = Reservation::where('user_id', $user_id)->where('id', $check_code->reservation_id)->first();

        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'not found');
        }
        $trip_id = $reservation->trip_id;
        $seats = $reservation->seats;
        if ($reservation->seats[0]->status == "unavailable") {
            CancelReservation::create([
                'count_seats' => count($seats),
                'amount' =>  count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100))),
                'is_confirmed' => true,
                'user_id' => $user_id,
                'trip_id' => $trip_id,
                'company_id' => $reservation->company_id,
                'date' => $reservation->trip->start_date,
            ]);
        }
        if ($reservation->seats[0]->status == "temporary") {
            CancelReservation::create([
                'count_seats' => count($seats),
                'amount' =>  count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100))),
                'is_confirmed' => false,
                'user_id' => $user_id,
                'trip_id' => $trip_id,
                'company_id' => $reservation->company_id,
                'date' => $reservation->trip->start_date,
            ]);
        }
        foreach ($seats as $index => $seat) {
            $seat->update([
                'status' => 'available',
                'name' => null,
                'is_selected' => false,
                'selected_user_id' => null,
                'age' => null,
                'gender' => null,
                'reservation_id' => null
            ]);
        }
        $trip = Trip::find($trip_id);
        $trip->seats_leaft = $trip->seats_leaft + count($seats);
        $trip->save();



        $payment = Payment::where('reservation_id', $reservation->id)->first();
        // $this->cancelPayment($payment->payment_id);
        PaymentReservations::where('reservation_id', $reservation->id)->delete();
        $reservation->delete();
        $params = Parameter::first();
        $user = User::find($user_id);

        $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";
        $data_notification = [
            'trip_id' => $trip_id,
        ];


        $startDateTime = Carbon::parse($reservation->trip->start_date);
        $data_notification = [
            'trip_id' => $reservation->trip->id,
        ];
        $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";


        $sourceCityName = $reservation->trip->source_city->getNameInLanguage($user->lang);
        $destinationCityName = $reservation->trip->destination_city->getNameInLanguage($user->lang);
        $date_trip =  Carbon::parse($reservation->trip->start_date)->toDateString();
        $timeSeparated = $startDateTime->format('g:i a');

        $message_notification = $user->lang == 'ar' ? " $params->temporary_reservation_cancel  من $sourceCityName إلى $destinationCityName بتاريخ $date_trip الساعة $timeSeparated "
            :  $params->temporary_reservation_cancel_en . "from" . $sourceCityName . " to " . $destinationCityName .  $date_trip . " at " . $timeSeparated;
        $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_temporary'));





        return $this->apiResponse([], self::STATUS_OK, 'reservation successfully');
    }

    public function cancelPayment($payment_id)
    {
        $payment = Http::retry(2, 5)->acceptJson()
            ->withBasicAuth('rehlat', 'rehlat@123')

            ->post('https://egate-t.fatora.me/api/cancel-payment', [
                'lang' => 'ar',
                "payment_id" => $payment_id,
            ]);
        if ($payment->serverError() === false) {

            $var = json_decode($payment);

            // $paymentId = $var->Data->paymentId;

            return $var->Data;
        }
    }

    public function request_confirm_reservation($book_id)
    {
        $user = auth()->user();
        $get_code = ConfirmReservationCode::create([
            'code' => random_int(100000, 999999),
            'user_id' => $user->id,
            'reservation_id' => $book_id,
        ]);
        app(SyriatelSms::class)->sendSms($user->phone, $get_code->code);
        return $this->apiResponse([], self::STATUS_OK, 'request reservation successfully');
    }



    //! need payment book_id is same reservation_id
    public function confirm_reservation(Request $request, $book_id)
    {
        $validate = $this->apiValidation($request, [
            'code' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;

        $user_id = auth()->user()->id;
        $reservation = Reservation::where([['user_id', $user_id], ['id', $book_id]])->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong id');
        }
        $check_code = ConfirmReservationCode::where([['user_id', $user_id], ['reservation_id', $book_id], ['code', $request->code]])->first();
        if (!$check_code) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong code');
        }

        foreach ($reservation->seats as $seat) {
            $seat->update([
                'status' => 'unavailable'
            ]);
        }
        PaymentReservations::create([
            'phone' => $reservation->phone,
            'company_id' => $reservation->company_id,
            'price' => count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100))),
            'is_temp_from_app' => false,
            'is_confirm_by_center' => false,
            'date' => $reservation->trip->start_date,
            'reservation_id' => $reservation->id,
        ]);
        $user = auth()->user();
        $rateIds = json_decode($user->rate_ids, true);
        if ($rateIds === null) {
            $rateIds = [];
        }
        $rateIds[] = $reservation->trip_id;
        $user->rate_ids = json_encode($rateIds);
        /** @var \App\Models\User $user **/
        $user->save();
        $user = User::find($user_id);
        $params = Parameter::first();
        $title = "رحلات";
        $data_notification = [
            'trip_id' => $reservation->trip_id,
        ];
        $message_notification = ($user->lang == 'ar') ? $params->temporary_reservation_confirmation : $params->temporary_reservation_confirmation_en;
        $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_confirmed'));
        return $this->apiResponse([], self::STATUS_OK, 'confirm reservation successfully');
    }

    public function select_seats(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'ids' => 'required|array',
            'ids.*' => 'exists:seats,id',
        ]);


        if ($validate instanceof Response) return $validate;

        $seats = Seat::whereIn('id', $request->ids)->get();
        $user_id = auth()->user()->id;
        foreach ($seats as $seat) {
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
        }
        $currentTime = Carbon::now();
        $currentTime = $currentTime->addHours(3);
        $trip_id = $seats[0]->trip->id;
        foreach ($seats as $seat) {
            broadcast(new \App\Events\SeatEvent($seat->number_seat, 'selected', $trip_id, "F"));
            $seat->update([
                'is_selected' => true,
                'selected_user_id' => $user_id,
                'selected_date' => $currentTime
            ]);
        }

        return $this->apiResponse([], self::STATUS_OK, 'select seats successfully');
    }


    public function unselect_seats(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'ids' => 'required|array',
            'ids.*' => 'exists:seats,id',
        ]);
        if ($validate instanceof Response) return $validate;

        $user_id = auth()->user()->id;
        // $seat = Seat::where('id', $request->id)->where('selected_user_id', $user_id)->first();
        $seats = Seat::whereIn('id', $request->ids)->where('selected_user_id', $user_id)->get();

        if (!$seats) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'you don\'t have permission to unselect this seat');
        }

        foreach ($seats as $seat) {
            broadcast(new \App\Events\SeatEvent($seat->number_seat, 'unselected', $seat->trip_id, "F"));
            $seat->update([
                'is_selected' => false,
            ]);
        }
        return $this->apiResponse([], self::STATUS_OK, 'unselect seats successfully');
    }
}
