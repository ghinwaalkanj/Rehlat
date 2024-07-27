<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\services\gateways\SyriatelSms;
use App\Models\ConfirmReservationCode;
use App\Models\PhoneVerification;
use App\Models\ProfileVerification;
use App\Models\User;
use Illuminate\Http\Request;

class ResendCodeController extends ApiController
{
    public function updateProfile()
    {
        $user = User::find(auth()->user()->id);
        $old_code = PhoneVerification::where('user_id', $user->id)->latest()->first();
        $get_code = PhoneVerification::create([
            'phone' => $old_code->phone,
            'code' => random_int(100000, 999999),
            'user_id' => $user->id,
        ]);
        $old_code->delete();
        app(SyriatelSms::class)->sendSms($get_code->phone, $get_code->code);
        return $this->apiResponse([], self::STATUS_OK, 'resend successfully');
    }
    // request_confirm_reservation
    public function requestConfirmReservation()
    {
        $user = auth()->user();
        $old_code = ConfirmReservationCode::where('user_id', $user->id)->latest()->first();
        $get_code = ConfirmReservationCode::create([
            'code' => random_int(100000, 999999),
            'user_id' => $user->id,
            'reservation_id' => $old_code->reservation_id,
        ]);
        $old_code->delete();
        app(SyriatelSms::class)->sendSms($user->phone, $get_code->code);
    }
    public function requestUpdateProfile()
    {
        $user = auth()->user();
        $old_code = ProfileVerification::where('user_id', $user->id)->latest()->first();
        $old_code->delete();
        $get_code = ProfileVerification::create([
            'user_id' => $user->id,
            'code' => random_int(100000, 999999),
        ]);
        app(SyriatelSms::class)->sendSms($user->phone, $get_code->code);
    }

    public function sendOtp()
    {
        $user = auth()->user();
        $old_code = ProfileVerification::where('user_id', $user->id)->latest()->first();
        $old_code->code = random_int(100000, 999999);
        $old_code->save();
        app(SyriatelSms::class)->sendSms($user->phone, $old_code->code);
    }
}
