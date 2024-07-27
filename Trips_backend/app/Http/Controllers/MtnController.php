<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Api\ApiController;
use App\Models\MtnOperation;
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

class MtnController extends ApiController
{
    public function activateMtn()
    {
        return 'done';
        $privateKey = file_get_contents(__DIR__ . '../../../../privatekey.pem');
        if ($privateKey === false) {
            echo "فشل في تحميل المفتاح الخاص من الملف.";
            exit;
        }

        // تحميل المفتاح العام من الملف
        $publicKey = file_get_contents(__DIR__ . '../../../../publickey.pem');
        if ($publicKey === false) {
            echo "فشل في تحميل المفتاح العام من الملف.";
            exit;
        }
        // return trim($privateKey);
        //9001000000051078

        $publicKey = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCu6LN3EJsr0iuDqDXdQAF7pXwU
        kREwhvXE6PQCT0XePeBatehjDzzIxBUQYzRdaxmPZdQyAhysim9z1PL8pf17jmAI
        wh09Wwbs7m/M+BXQ2J7ANpNBE6pHoDkeoTzk0xdxIlHoRRtIA8reQV74aKX2FNbc
        fqyIM19d8PKs9NcXDQIDAQAB';
        $publicKeyInOneLine = str_replace(["\r", "\n", " "], '', $publicKey);
        $data = [
            'Key' => $publicKeyInOneLine,
            'Secret' => '14132136',
            'Serial' => '831113872832'
        ];
        // $data  = json_encode($data, true);
        // return $data;
        //remove / from $data->key
        // $data = str_replace(["\\", "\\", " "], '', $data);

        $jsonData = json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        $jsonData = str_replace(["\\r", "\\n", " "], '', $jsonData);
        // return $jsonData;

        $hash = hash('sha256', $jsonData);

        openssl_private_encrypt($hash, $encrypted, $privateKey);
        $base64EncryptedSignatureHeader = base64_encode($encrypted);
        $headers = [
            'Subject' => '9001000000051078',
            "Request-Name" => 'pos_web/pos/activate',
            'X-Signature' => $base64EncryptedSignatureHeader,
            'Accept-Language' => 'ar'
        ];
        return $data;
        $response = Http::withHeaders($headers)
            ->post('https://cashmobile.mtnsyr.com:9000', $data);
        return $response->body();
    }

    public function createPayment(Request $request)
    {
        $validate  = $this->apiValidation($request, [
            'reservation_id' => 'required',
            'phone' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;

        $privateKey = file_get_contents(__DIR__ . '../../../../privatekey.pem');
        if ($privateKey === false) {
            echo "error2";
            exit;
        }
        $user = auth()->user();
        $invoice_num = random_int(111111111111111, 999999999999999);
        $session_num = random_int(111111111111111, 999999999999999);
        $reservation = Reservation::where('id', $request->reservation_id)->first();
        if (!$reservation) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'no reservation');
        }
        $amount = count($reservation->seats) * ($reservation->trip->ticket_price + ($reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100)));

        $payment = Payment::where('user_id', $user->id)->where('reservation_id', $request->reservation_id)->where('status', 0)->latest()->first();

        if ($payment) {
            $payment->update([
                'payment_id'    => $invoice_num,
                'amount'        => $amount,
            ]);
        } else {
            $payment = Payment::create([
                'name' => 'mtn',
                'payment_id'    => $invoice_num,
                'reservation_id' => $request->reservation_id,
                'user_id' => $user->id,
                'amount'        => $amount,
                'status'        => 0,

            ]);
        }
        $body = [
            'Amount' => $amount * 100,
            'Invoice' => $invoice_num,
            'Session' => $session_num,
            'TTL' => 15,
        ];
        $jsonDataString = json_encode($body); //for sing
        $jsonDataString = str_replace(["\\r", "\\n", "\\", " "], '', $jsonDataString);
        openssl_sign($jsonDataString, $signature, $privateKey, OPENSSL_ALGO_SHA256);
        $base46EncryptedSignatureHeader = base64_encode($signature);
        $headers = [
            'Subject' => '9001000000051078',
            "Request-Name" => 'pos_web/invoice/create',
            'X-Signature' => $base46EncryptedSignatureHeader,
            'Accept-Language' => 'ar'
        ];
        $response = Http::withHeaders($headers)
            ->post('https://cashmobile.mtnsyr.com:9000', $body);
        $res_data = json_decode($response->body(), true);
        if ($res_data['Errno'] == 0) {
            $guid = (string) random_int(111111111111111, 999999999999999);
            $initPayment = $this->makePayment($invoice_num, $request->phone, $guid);
            if ($initPayment['Errno'] == 0) {
                MtnOperation::create([
                    'operation_number' => $initPayment['OperationNumber'],
                    'invoice_number' => $invoice_num,
                    'user_id' => $user->id,
                    'reservation_id' => $request->reservation_id,
                    'guid' => $guid,
                    'phone' => $request->phone
                ]);
                return $this->apiResponse(['operation_number' => $initPayment['OperationNumber'],], self::STATUS_OK, 'success');
            } else {
                return $this->apiResponse([], self::STATUS_BAD_REQUEST, $initPayment['Error']);
            }
        } else {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, $res_data['Error']);
        }
    }
    public function makePayment($invoice_num, $phone, $guid)
    {
        $privateKey = file_get_contents(__DIR__ . '../../../../privatekey.pem');
        if ($privateKey === false) {
            echo "error2";
            exit;
        }
        $body = [
            'Invoice' => $invoice_num,
            'Phone' => $phone,
            'Guid' => $guid,
        ];
        $jsonDataString = json_encode($body); //for sing
        $jsonDataString = str_replace(["\\r", "\\n", "\\", " "], '', $jsonDataString);
        openssl_sign($jsonDataString, $signature, $privateKey, OPENSSL_ALGO_SHA256);
        $base46EncryptedSignatureHeader = base64_encode($signature);
        $headers = [
            'Subject' => '9001000000051078',
            "Request-Name" => 'pos_web/payment_phone/initiate',
            'X-Signature' => $base46EncryptedSignatureHeader,
            'Accept-Language' => 'ar'
        ];

        $response = Http::withHeaders($headers)
            ->post('https://cashmobile.mtnsyr.com:9000', $body);
        $res_data =   json_decode($response->body(), true);
        return $res_data;
    }
    public function confirmPayment(Request $request)
    {
        $privateKey = file_get_contents(__DIR__ . '../../../../privatekey.pem');
        if ($privateKey === false) {
            echo "error2";
            exit;
        }
        $validate  = $this->apiValidation($request, [
            'operation_number' => 'required',
            'code' => "required"
        ]);
        if ($validate instanceof Response) return $validate;

        $user = auth()->user();
        $mtn_operation = MtnOperation::where('operation_number', $request->operation_number)
            ->where('user_id', $user->id)
            ->first();
        if (!$mtn_operation) {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'not found');
        }
        $body = [
            'Phone' => $mtn_operation->phone,
            'Guid' => $mtn_operation->guid,
            "OperationNumber" => (int) $mtn_operation->operation_number,
            'Invoice' => (int) $mtn_operation->invoice_number,
            "Code" => base64_encode(hash('sha256', $request->code, true))
        ];
        $jsonDataString = json_encode($body); //for sing
        $jsonDataString = str_replace(["\\r", "\\n", "\\", " "], '', $jsonDataString);
        openssl_sign($jsonDataString, $signature, $privateKey, OPENSSL_ALGO_SHA256);
        $base46EncryptedSignatureHeader = base64_encode($signature);
        $headers = [
            'Subject' => '9001000000051078',
            "Request-Name" => 'pos_web/payment_phone/confirm',
            'X-Signature' => $base46EncryptedSignatureHeader,
            'Accept-Language' => 'ar'
        ];
        $response = Http::withHeaders($headers)
            ->post('https://cashmobile.mtnsyr.com:9000', $body);

        $res_data =  json_decode($response->body(), true);
        if ($res_data['Errno'] == 0) {
            $reservation = Reservation::where([['user_id', $user->id], ['id', $mtn_operation->reservation_id]])->first();
            if (!$reservation) {
                return $this->apiResponse([], self::STATUS_FORBIDDEN, 'wrong id');
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
        } else {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, $res_data['Error']);
        }
    }
}




//{"Errno":0,"Settings":{"Currency":{"Code":760,"Brief":"SYP","Fractional":100},"Session":0,"Invoice":0,"Allowed":{"Payment":true},"Limits":{},"Description":{"Business":"رحلات","Shop":"رحلات","Address":" Mtnالبرامكة جانب مركز ","Phone":"963952384466"}},"CountAbuse":3}


// public function createPayment()
//     {
//         $privateKey = file_get_contents(__DIR__ . '../../../../privatekey.pem');
//         if ($privateKey === false) {
//             echo "error2";
//             exit;
//         }

//         $publicKey = file_get_contents(__DIR__ . '../../../../publickey.pem');
//         if ($publicKey === false) {
//             echo "error";
//             exit;
//         }
//         $body = [
//             'Amount' => 10000,
//             'Invoice' => 21418749,
//             'Session' => 23438479235,
//             'TTL' => 15,
//         ];
//         // $tt = '{"Amount":10000,"Invoice":21418748,"Session":98724988,"TTL":15}';
//         $jsonDataString = json_encode($body); //for sing
//         $jsonDataString = str_replace(["\\r", "\\n", "\\", " "], '', $jsonDataString);
//         openssl_sign($jsonDataString, $signature, $privateKey, OPENSSL_ALGO_SHA256);
//         $base46EncryptedSignatureHeader = base64_encode($signature);


//         // return base64_encode($encrypted);
//         // openssl_sign($tt, $signature, $privateKey, OPENSSL_ALGO_SHA256);

//         // return response()->json($body);
//         // return response()->json($jsonData = json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE)); //for sing

//         // $jsonData = json_encode($body); //for sing
//         // $jsonData = str_replace(["\\r", "\\n", "\\", " "], '', $jsonData);
//         // return [str_replace(["\\r", "\\n", "\\", " "], '', $tt),$jsonData];
//         // dd([$tt,$jsonData]);
//         // return response()->json($jsonData);
//         // $hash = hash('sha256', $tt);
//         // openssl_private_encrypt($hash, $encrypted, $privateKey);
//         // return $encrypted;
//         // $base64EncryptedSignatureHeader = base64_encode($signature);
//         $headers = [
//             'Subject' => '9001000000051078',
//             "Request-Name" => 'pos_web/invoice/create',
//             'X-Signature' => $base46EncryptedSignatureHeader,
//             'Accept-Language' => 'ar'
//         ];


//         // $signature = base64_decode($base64EncryptedSignatureHeader);
//         // $verificationResult = openssl_public_decrypt($signature, $decrypted, $publicKey);

//         // // Compare decrypted signature with hash
//         // if ($verificationResult && $decrypted === $hash) {
//         //     // Signature verification successful
//         //     return 'fasdkfj';
//         // } else {
//         //     // Signature verification failed
//         //     return "Signature verification failed";
//         // }

//         // return '3';
//         // return $headers;
//         // return $body;
//         $response = Http::withHeaders($headers)
//             ->post('https://cashmobile.mtnsyr.com:9000', $body);
//         return json_decode($response->body(), true);
//         // return $response->body()
//     }