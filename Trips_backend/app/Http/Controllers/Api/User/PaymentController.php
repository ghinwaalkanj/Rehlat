<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Parameter;
use App\Models\Payment;
use App\Models\PaymentReservations;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\User;
use App\Notifications\SendPushNotification;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Http;

class PaymentController extends ApiController
{
    public function createFatoraPayment(Request $request)
    {
        $user = auth()->user();
        $validate  = $this->apiValidation($request, [
            'reservation_id' => 'required'
        ]);
        if ($validate instanceof Response) return $validate;
        $host = "https://rehlat.sy/backend/api/v1/fatora/paid/$user->id/$request->reservation_id";
        // fatora/paid/{user_id}/{reservation_id}
        $reservation = Reservation::where('id', $request->reservation_id)->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'no reservation');
        }
        $amount = count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100)));
        $payment = Http::retry(2, 5)->acceptJson()
            ->withBasicAuth('rehlat', 'rehlat@123')

            ->post('https://egate-t.fatora.me/api/create-payment', [
                'lang' => 'ar',
                'terminalId' => '14740059',
                'amount'    => $amount,
                "callbackURL" => "https://www.google.com",
                "triggerURL" => $host,
            ]);
        if ($payment->serverError() === false) {

            $var = json_decode($payment);
            $payment = Payment::where('user_id', $user->id)->where('reservation_id', $request->reservation_id)
                ->where('status', 0)->latest()->first();
            $paymentId = $var->Data->paymentId;
            if ($payment) {
                $payment->update([
                    'payment_id'    => $paymentId,
                    'amount'        => $amount,
                ]);
            } else {
                $payment = Payment::create([
                    'name' => 'fatora',
                    'payment_id'    => $paymentId,
                    'reservation_id' => $request->reservation_id,
                    'user_id' => $user->id,
                    'amount'        => $amount,
                    'status'        => 0,

                ]);
            }

            return $var->Data;
        }
    }

    public function fatora_paid($user_id, $reservation_id)
    {
        // $user_id = auth()->user()->id;
        $reservation = Reservation::where([['user_id', $user_id], ['id', $reservation_id]])->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong id');
        }
        // $check_code = ConfirmReservationCode::where([['user_id', $user_id], ['reservation_id', $book_id], ['code', $request->code]])->first();
        // if (!$check_code) {
        //     return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong code');
        // }

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
        // $user = auth()->user();
        $user = User::find($user_id);
        $rateIds = json_decode($user->rate_ids, true);
        if ($rateIds === null) {
            $rateIds = [];
        }
        $seats = $reservation->seats;
        foreach ($seats as $index => $seat) {

            $seat->update([
                'status' => 'unavailable',
                'is_selected' => true,
            ]);
        }

        $trip = Trip::find($reservation->trip_id);
        $trip->seats_leaft = $trip->seats_leaft - count($reservation->seats);
        $trip->save();

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
        $message_notification = ($user->lang == 'ar') ? $params->paid_reservation_confirmation : $params->paid_reservation_confirmation_en;
        $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_confirmed'));
        return $this->apiResponse([], self::STATUS_OK, 'confirm reservation successfully');
    }
}
 