<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Api\ApiController;
use App\Models\Parameter;
use App\Models\Payment;
use App\Models\PaymentReservations;
use App\Models\Reservation;
use App\Models\SyriatelPayment;
use App\Models\SyriatelToken;
use App\Models\Trip;
use App\Models\User;
use App\Notifications\SendPushNotification;
use Carbon\Carbon;
use GuzzleHttp\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class SyriatelController extends ApiController
{
    public function getTokenPayment()
    {

        $url = 'https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/getToken/';

        $client = new Client(['verify' => false]);

        $response = $client->post($url, [
            'headers' => [
                'Content-Type' => 'application/json',
            ],
            'json' => [
                'username' => 'Rehlat',
                'password' => 'Rehlat_$&4648Cr!'
            ],
        ]);
        $body =  $response->getBody()->getContents();
        $data = json_decode($body, true);
        $token = $data['token'];
        SyriatelToken::create([
            'token' => $token,
        ]);
        return true;
    }

    public function requestPayment(Request $request)
    {
        $user = auth()->user();

        $validate = Validator::make($request->all(), [
            'reservation_id' => 'required',
            'phone' => 'required',
        ]);
        if ($validate->fails()) {
            return response($validate->errors(), 422);
        }

        $res_get_token = $this->getTokenPayment();
        if ($res_get_token != true) {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'can not get token');
        }

        $client = new Client(['verify' => false]);

        $token = SyriatelToken::latest()->first();
        if (!$token || Carbon::parse($token->created_at)->diffInMinutes(Carbon::now()) >= 5) {

            $client = new Client(['verify' => false]);

            $response_token = $client->post('https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/getToken', [
                'headers' => [
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'username' => 'Rehlat',
                    'password' => 'Rehlat_$&4648Cr!'
                ],
            ]);
            $body_token =  $response_token->getBody()->getContents();
            $data_token = json_decode($body_token, true);
            $token_res = $data_token['token'];
            $token = SyriatelToken::create([
                'token' => $token_res,
            ]);
        }

        $uuid = Str::uuid();
        $url = 'https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/paymentRequest';
        $reservation = Reservation::where('id', $request->reservation_id)->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'no reservation');
        }
        $amount = count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100)));
        $response = $client->post($url, [
            'headers' => [
                'Content-Type' => 'application/json',
            ],
            'json' => [
                "customerMSISDN" => $request->phone,
                "merchantMSISDN" => "0989913455",
                "amount" => (string) $amount,
                // "amount" => (string) 10,
                "transactionID" => $uuid,
                "token" => $token->token
            ]
        ]);
        // $status = $response->getStatusCode();
        $body = $response->getBody()->getContents();

        $data = json_decode($body, true);


        $payment = Payment::where('user_id', $user->id)->where('reservation_id', $request->reservation_id)->where('status', 0)->latest()->first();

        if ($payment) {
            $payment->update([
                'payment_id'    => $uuid,
                'amount'        => $amount,
            ]);
        } else {
            $payment = Payment::create([
                'name' => 'mtn',
                'payment_id'    => $uuid,
                'reservation_id' => $request->reservation_id,
                'user_id' => $user->id,
                'amount'        => $amount,
                'status'        => 0,

            ]);
        }
        if ($data['errorCode'] == "0") {
            return $this->apiResponse([
                'transId' => $uuid
            ], self::STATUS_OK, 'تم ارسال الرمز بنجاح');
        } else {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'حدث خطأ ما يرجى المحاولة لاحقاً' . $data['errorDesc'] ?? "");
        }
    }

    public function sendOtp(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'otp' => 'required',
            'transId' => 'required',
            'phone' => 'required',
            // 'transaction_id' => 'required',
        ]);
        if ($validate->fails()) {
            return response($validate->errors(), 422);
        }

        $client = new Client(['verify' => false]);

        $user = auth()->user();
        $token = SyriatelToken::latest()->first();
        if (!$token || Carbon::parse($token->created_at)->diffInMinutes(Carbon::now()) >= 5) {

            $client = new Client(['verify' => false]);

            $response_token = $client->post('https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/getToken', [
                'headers' => [
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'username' => 'Rehlat',
                    'password' => 'Rehlat_$&4648Cr!'
                ],
            ]);
            $body_token =  $response_token->getBody()->getContents();
            $data_token = json_decode($body_token, true);
            $token_res = $data_token['token'];
            $token = SyriatelToken::create([
                'token' => $token_res,
            ]);
        }

        $url = 'https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/paymentConfirmation';

        $response = $client->post($url, [
            'headers' => [
                'Content-Type' => 'application/json',
            ],
            'json' => [
                'OTP' => $request->otp,
                "merchantMSISDN" => "0989913455",
                "transactionID" => $request->transId,
                "token" => $token->token,
            ],
        ]);
        $status = $response->getStatusCode();
        $body = $response->getBody()->getContents();

        $data = json_decode($body, true);


        if ($data['errorCode'] == "-8") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'هذا الرقم لا يحتوي على حساب سيرياتيل كاش',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'هذا الرقم لا يحتوي على حساب سيرياتيل كاش');
        } elseif ($data['errorCode'] == "-13") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'هذا الحساب لايحتوي على رصيد يكفي لاجراء العملية',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'هذا الحساب لايحتوي على رصيد يكفي لاجراء العملية');
        } elseif ($data['errorCode'] == "-6") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'هذا الرقم غير نشط',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'هذا الرقم غير نشط');
        } elseif ($data['errorCode'] == "-17") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'لايمكن دفع هذه العملية لانه يتجاوز الحد المسموح من عمليات الدفع خلال اليوم',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'لايمكن دفع هذه العملية لانه يتجاوز الحد المسموح من عمليات الدفع خلال اليوم');
        } elseif ($data['errorCode'] == "-96") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'الرمز خاطئ',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'الرمز خاطئ');
        } elseif ($data['errorCode'] == "-104") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'لقدانتهت صلاحية هذه الرمز يرجى اعادة طلب رمز جديد',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'لقدانتهت صلاحية هذه الرمز يرجى اعادة طلب رمز جديد');
        } elseif ($data['errorCode'] == "-95") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'تم تجاوز العدد المسموح من المحاولات يرجى المحاولة خلال دقائق',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'تم تجاوز العدد المسموح من المحاولات يرجى المحاولة خلال دقائق');
        } elseif ($data['errorCode'] == "-500") {
            // return response()->json([
            //     'error' => $data['errorDesc'],
            //     'message' => 'لقد انتهت مدة الجلسة يرجى اعادة المحاولة',
            //     'status' => false,
            // ], 400);
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'لقد انتهت مدة الجلسة يرجى اعادة المحاولة');
        }

        if ($data['errorCode'] == "0") {
            $payment = Payment::where('payment_id', $request->transId)->first();
            if (!$payment) {
                return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'wrong trans id');
            }
            $reservation = Reservation::where([['user_id', $user->id], ['id', $payment->reservation_id]])->first();
            if (!$reservation) {
                return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong id');
            }
            SyriatelPayment::create([
                'uuid' => $request->transId,
                'otp' => $request->otp,
                'phone' => $request->phone,
                // 'transaction_id' => $request->transaction_id,
            ]);
            PaymentReservations::create([
                'phone' => $reservation->phone,
                'company_id' => $reservation->company_id,
                'price' => count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100))),
                'is_temp_from_app' => false,
                'is_confirm_by_center' => false,
                'date' => $reservation->trip->start_date,
                'reservation_id' => $reservation->id,
            ]);
            $user = User::find($user->id);
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
    /*************************** */
    public function checkPayment(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'transaction_id' => 'required',
        ]);
        if ($validate->fails()) {
            return response($validate->errors(), 422);
        }

        $payment = SyriatelPayment::where('transaction_id', $request->transaction_id)->first();

        if (!$payment) {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'لايوجد عملية بهذا التعريف');
        }

        $client = new Client(['verify' => false]);

        $token = SyriatelToken::latest()->first();
        if (!$token || Carbon::parse($token->created_at)->diffInMinutes(Carbon::now()) >= 5) {

            $client = new Client(['verify' => false]);

            $response_token = $client->post('https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/getToken', [
                'headers' => [
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'username' => 'Rehlat',
                    'password' => 'Rehlat_$&4648Cr!'
                ],
            ]);
            $body_token =  $response_token->getBody()->getContents();
            $data_token = json_decode($body_token, true);
            $token_res = $data_token['token'];
            $token = SyriatelToken::create([
                'token' => $token_res,
            ]);
        }


        $url = 'https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/paymentConfirmation';

        $response = $client->post($url, [
            'headers' => [
                'Content-Type' => 'application/json',
            ],
            'json' => [
                'OTP' => $payment->otp,
                "merchantMSISDN" => "0989913455",
                "transactionID" => $payment->uuid,
                "token" => $token->token,
            ],
        ]);
        $status = $response->getStatusCode();
        $body = $response->getBody()->getContents();

        $data = json_decode($body, true);
        if ($data && $data['errorCode'] == "0") {
            return response()->json([
                'status' => true,
                'value' => 1
            ], 200);
        }
        return response()->json([
            'status' => true,
            'value' => 0
        ], 200);
    }



    public function resendOtp(Request $request)
    {
        $validate = Validator::make($request->all(), [
            'phone' => 'required',
            'transId' => 'required',
        ]);
        if ($validate->fails()) {
            return response($validate->errors(), 422);
        }



        $client = new Client(['verify' => false]);

        $token = SyriatelToken::latest()->first();
        if (!$token || Carbon::parse($token->created_at)->diffInMinutes(Carbon::now()) >= 5) {

            $client = new Client(['verify' => false]);

            $response_token = $client->post('https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/getToken', [
                'headers' => [
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'username' => 'Rehlat',
                    'password' => 'Rehlat_$&4648Cr!'
                ],
            ]);
            $body_token =  $response_token->getBody()->getContents();
            $data_token = json_decode($body_token, true);
            $token_res = $data_token['token'];
            $token = SyriatelToken::create([
                'token' => $token_res,
            ]);
        }


        $url = 'https://Merchants.syriatel.sy:1443/ePayment_external_Json/rs/ePaymentExternalModule/resendOTP';

        $response = $client->post($url, [
            'headers' => [
                'Content-Type' => 'application/json',
            ],
            'json' => [
                "merchantMSISDN" => "0989913455",
                "transactionID" => $request->transId,
                "token" => $token->token,
            ],
        ]);
        $status = $response->getStatusCode();
        $body = $response->getBody()->getContents();

        $data = json_decode($body, true);
        if ($data && $data['errorCode'] == "0") {
            // return response()->json([
            //     'status' => true,
            // ], 200);
            return $this->apiResponse([], self::STATUS_OK, 'success');
        } else {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'error happen please try again');
        }
    }
}
