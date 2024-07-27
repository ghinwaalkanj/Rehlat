<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class AdminAuthController extends ApiController
{
    public function login( Request $request)
    {
        $validate = $this->apiValidation($request,[
            'username'  => 'required',
            'password' => 'required',
        ]);
        if($validate instanceof Response) return $validate;

        $admin = Admin::where('username',$request->username)->first();
        if(!$admin || !Hash::check($request->password,$admin->password)){
            return $this->apiResponse([],self::STATUS_NOT_AUTHENTICATED,' اسم المستخدم أو كلمة السر غير صحيحة');
        }
       $token =  Auth::guard('admin')->login($admin);
        return response()->json([
            'data'=>$admin,
            'token' =>$token,
        ]);
    }
}
