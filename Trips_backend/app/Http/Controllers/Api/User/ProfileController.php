<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\ProfileResource;
use App\Http\services\gateways\SyriatelSms;
use App\Models\PhoneVerification;
use App\Models\ProfileVerification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Symfony\Component\HttpKernel\Profiler\Profile;

class ProfileController extends ApiController
{
    public function index()
    {
        $user = auth()->user();
        return $this->apiResponse(['profile' => new ProfileResource($user)], self::STATUS_OK, 'get profile successfully');
    }

    public function update(Request $request)
    {


        $user = User::find(auth()->user()->id);
        // if(!$request->name){
        //     return $this->apiResponse([]);
        // }
        // return $request->all();
        $check_code = ProfileVerification::where('user_id', $user->id)->latest()->first();
        if (!$check_code) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'your code is incorrect or invalid');
        }
        if ($request->code != $check_code->code) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'your code is incorrect or invalid');
        }
        $prev_phone = $user->phone;
        $user->update([
            'name' => $request->name,
            'age' => $request->age,
            'gender' => $request->gender,
        ]);
        if ($request->phone && $request->phone != $prev_phone) {

            $get_code = PhoneVerification::create([
                'phone' => $request->phone,
                'code' => random_int(100000, 999999),
                'user_id' => $user->id,
            ]);
            app(SyriatelSms::class)->sendSms($request->phone, $get_code->code);
            // $user->mobile_verified = 0 ;
            // $user->save();
        }

        return $this->apiResponse([], self::STATUS_OK, 'update user successfully');
    }

    public function updatePhone(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'code' => 'required',
            'phone' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        $user = auth()->user();
        $check = PhoneVerification::where('user_id', $user->id)->where('phone', $request->phone)
            ->where('code', $request->code)->latest()->first();
        if (!$check) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'your code is incorrect or invalid');
        }
        $check_if_phone_exists = User::where('phone', $request->phone)->where('id', '!=', $user->id)->first();
        if ($check_if_phone_exists) {
            $check_if_phone_exists->delete();
        }
        $user->phone = $request->phone;
        /** @var \App\Models\User $user **/
        $user->save();
        return $this->apiResponse([], self::STATUS_OK, 'update phone successfully');
    }

    public function changeLanguage(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'lang' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        $user = auth()->user();
        $user->lang = $request->lang;
        /** @var \App\Models\User $user **/
        $user->save();
        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }
}
