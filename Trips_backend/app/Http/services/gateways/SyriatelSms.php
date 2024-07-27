<?php

namespace App\Http\services\gateways;


use Illuminate\Support\Facades\Log;



class SyriatelSms
{


    public function sendSms($phone, $code)
    {
        $client = new \GuzzleHttp\Client(['verify' => false]);

        $params = [
            'user_name' => env('SMS_SYRIATEL_USERNAME'),
            'password' => env('SMS_SYRIATEL_PASSWORD'),
            'sender' => env('SMS_SYRIATEL_SENDER'),
            'code' => $code,
            'to' => $phone,
        ];
        //$url = 'https://bms.syriatel.sy/API/SendSMS.aspx?job_name=test&user_name='.$params['user_name'].'&password='.$params['password'].'&sender='.$params['sender'].'&msg='.$params['msg'].'&to='.$params['to'];
        // $url = 'http:///api/syriatel-sendsms?phone='.$params['to'].'&code='.$params['code'];
        $url = 'https://bms.syriatel.sy/API/SendTemplateSMS.aspx?user_name=Rehlat1&password=P@123456&template_code=Rehlat1_T3&param_list='.$code.'&sender=Rehlat&to='.$phone;

        $response = $client->request('GET', $url);
        $jsonData = json_decode($response->getBody(), true);
        $message = 'Received data from API: ' . json_encode($jsonData);
        Log::info($message);
        $response->getStatusCode();
        // return $response->getBody();
        try {
            $status_code = $response->getStatusCode();
            if ($status_code == 200) {
                return true;
            } else {
                info("Syriatel error status!");
                return false;
            }
        } catch (\Exception $e) {
            info("Syriatel has been trying to send sms to $phone but operation failed !");
            return false;
        }
        $message = " : رمز التفعيل هو";
    }
}
