<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\services\gateways\SyriatelSms;
use App\Http\services\VerificationServices;
use App\Models\PaymentGatewayStatus;
use App\Models\PhoneVerification;
use App\Models\ProfileVerification;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class UserController extends ApiController
{

    public $sms_services;


    public function __construct(VerificationServices $sms_services)
    {
        $this->sms_services = $sms_services;
    }


    public function updateFcm(Request $request)
    {
        /** @var \App\Models\User $user **/
        $user = auth()->user();
        $user->update([
            'fcm_token' => $request->fcm_token
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'successfully');
    }
    public function requestUpdateProfile()
    {
        $user = auth()->user();
        $get_code = ProfileVerification::create([
            'user_id' => $user->id,
            'code' => random_int(100000, 999999),
        ]);
        app(SyriatelSms::class)->sendSms($user->phone, $get_code->code);
        return $this->apiResponse([], self::STATUS_OK, 'send otp successfully');
    }

    public function send_otp(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'phone' => 'required|max:255'
        ]);
        if ($validate instanceof Response) return $validate;


        // $phone_code = PhoneVerification::create([
        //     'phone' => $request->phone,
        //     'code' => '000000'
        // ]);
        $verification = [];
        if (!$request->is_register) {
            $verification['name'] = $request->name;
            $check = User::where('phone', $request->phone)->first();
            if ($check) {
                return $this->apiResponse([], self::STATUS_BAD_REQUEST, 'هذا الرقم موجود مسبقاََ');
            }
        }

        $verification['phone'] = $request->phone;

        $verification_data =  $this->sms_services->setVerificationCode($verification);
        $message = $this->sms_services->getSMSVerifyMessageByAppName($verification_data->code);
        app(SyriatelSms::class)->sendSms($request->phone, $verification_data->code);
        return  $this->apiResponse([], self::STATUS_OK, __('api_response.success_send_otp'));
    }
    public function validate_phone_number_and_login(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'phone' => 'required|max:255',
            'code' => 'required|max:6|min:6'
        ]);
        if ($validate instanceof Response) return $validate;

        $fourHoursAgo = Carbon::now()->subHours(6);

        $check_code = PhoneVerification::where([['phone', $request->phone], ['code', $request->code]])
            ->whereDate('created_at', '>=', $fourHoursAgo)->first();
        if ($check_code) {
            // if ($request->code == "000000") {
            //     $get_name = PhoneVerification::where('phone', $request->phone)->first();
            //     $user = User::where('phone', $request->phone)->first();
            //     if (!$user) {
            //         $user =  User::create([
            //             'name' => $get_name->name,
            //             'phone' => $request->phone,
            //             'mobile_verified' => true,
            //             'rate_ids' => '[]'
            //         ]);
            //     }
            // } else {
            $user = User::where('phone', $request->phone)->first();

            if (!$user) {
                $user =  User::create([
                    'name' => $check_code->name,
                    'phone' => $request->phone,
                    'mobile_verified' => true,
                    'rate_ids' => '[]'
                ]);
            }
            // }
            $user->update(['jti' => Str::uuid()->toString()]);
            $token = Auth::login($user);
            return $this->apiResponse(['user' => $user, 'token' => $token], self::STATUS_OK, __('api_response.success_verify'));
        } else {
            return $this->apiResponse([], self::STATUS_BAD_REQUEST, __('api_response.code_not_valid'));
        }
    }

    public function methods(Request $request)
    {
        $lang =  ($request->hasHeader("Accept-Language")) ? $request->header("Accept-Language") : "en";
        $payments = PaymentGatewayStatus::first();
        return $this->apiResponse([
            'methods' => [
                [
                    "name" => $lang == "en" ? "fatora" : "فاتورة",
                    // "name_ar" => "فاتورة",
                    "disable" => $payments->fatora,
                    "logo" => url('backend/companies-logos/fatora.jpg'),
                    "banks" => [
                        ["name" => $lang == "en" ? "Cham Bank" : "بنك الشام", "logo" => url('backend/companies-logos/sham.jpg')],
                        ["name" => $lang == "en" ? "Syria Gulf Bank" : "بنك سوريا والخليج", "logo" => url('backend/companies-logos/syriaandgulf.jpg')],
                        ["name" => $lang == "en" ? "Syria International Islamic Bank" : "بنك سورية الدولي الإسلامي", "logo" => url('backend/companies-logos/eslame.jpg')],
                    ],
                ],
                [
                    "name" => $lang == "en" ? "mtn_cash" : "ام تي ان كاش",
                    // "name_ar" => "ام تي ان كاش",
                    "disable" => $payments->mtn_cash,
                    "logo" => url('backend/companies-logos/mtncash.jpg'),
                ],
                [
                    "name" => "syriatel_cash",
                    "name" => $lang == "en" ? "syriatel_cash" : "سيرياتيل كاش",
                    // "name_ar" => "سيرياتيل كاش",
                    "disable" => $payments->syriatel_cash,
                    "logo" => url('backend/companies-logos/syriatel.jpg'),
                ],
            ]
        ], self::STATUS_OK, 'get successfully');
    }
}
