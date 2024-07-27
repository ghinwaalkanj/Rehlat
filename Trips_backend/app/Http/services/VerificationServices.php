<?php

namespace App\Http\services;

use App\Models\ChangeMobile;
use App\Models\ForgetPasswordCode;
use App\Models\Lawyer;
use App\Models\LawyerSubscribeRequest;
use App\Models\LawyerVerification;
use App\Models\PhoneVerification;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;


class VerificationServices
{

    public function setVerificationCode($data)
    {
        $code = random_int(100000, 999999);
        $data['code'] = $code;
        PhoneVerification::whereNotNull('phone')->where(['phone' => $data['phone']])->delete();
        return PhoneVerification::create([
            'phone' => $data['phone'],
            'code' => $code,
            'name' =>$data['name']??null
        ]);
    }

    public function getSMSVerifyMessageByAppName($code)
    {
        $message = " رمز التفعيل لتطبيق  هو : ";
        // $message = "<#> this is code test:0000\nFA+9qCX9FSu";
        return $message.$code;
    }

    
}
