<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Company;
use App\Models\UserCompany;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use PHPOpenSourceSaver\JWTAuth\Facades\JWTAuth as FacadesJWTAuth;
use Tymon\JWTAuth\Facades\JWTFactory;
use Tymon\JWTAuth\Facades\JWTAuth;



class AuthController extends ApiController
{
    public function login(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'username'  => 'required',
            'password' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;

        $company = UserCompany::where('username', $request->username)->first();
        if (!$company || !Hash::check($request->password, $company->password)) {
            return $this->apiResponse([], self::STATUS_NOT_AUTHENTICATED, 'اسم المستخدم  أو كلمة السر غير صحيحة');
        }
        if ($company->is_active == false) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'هذا الحساب موقف حالياََ');
        }
        $roles = [];
        if ($company->roles) {
            foreach ($company->roles as $role) {
                array_push($roles, $role->name_en);
            }
        }
        $customPayload = [
            'user_id' => $company->id,
            'roles' => $roles,

        ];
        // $token =  Auth::guard('company')->login($company);

        $customClaims = ['foo' => 'bar', 'baz' => 'bob'];

        $token = FacadesJWTAuth::claims(['roles' => $roles])->fromUser($company, $customPayload);
        // $payload = FacadesJWTAuth
        //     ::myCustomString('Foo Bar')
        //     ->myCustomArray(['Apples', 'Oranges'])
        //     ->myCustomObject($company)
        //     ->make();

        // return $token = FacadesJWTAuth::encode($payload);
        // return $payload = FacadesJWTAuth::parseToken()->getPayload();;
        $real_company = Company::find($company->company_id);
        $company->logo =url('backend/companies-logos/' . $real_company->logo);
        // $company->logo = url('companies-logos/' . $real_company->logo);
        $company->name_ar = $real_company->name_ar;
        return response()->json([
            'data' => $company,
            'token' => $token,
            'roles' => $roles
        ]);
    }
}
