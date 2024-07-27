<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;

use App\Http\Resources\Company\UserCompanyResource;
use App\Models\CompanyPermission as ModelsCompanyPermission;
use App\Models\UserCompany;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class CompanyPermission extends ApiController
{
    public function index()
    {
        $company_id = auth('company')->user()->company_id;
        $users = UserCompany::where('company_id', $company_id)->get();

        return $this->apiResponse(['users' => UserCompanyResource::collection($users)], self::STATUS_OK, 'get successfully');
    }

    public function getPermissions()
    {
        $permissions = ModelsCompanyPermission::all();
        return $this->apiResponse(['permissions' => $permissions], self::STATUS_OK, 'get successfully');
    }
    public function getUserCompanyById($id)
    {
        $company_id = auth('company')->user()->company_id;
        $user = UserCompany::where('company_id', $company_id)->where('id', $id)->first();
        if(!$user){
            return $this->apiResponse([],self::STATUS_NOT_FOUND,'not found');
        }
        return $this->apiResponse(['user' => new UserCompanyResource($user)], self::STATUS_OK, 'get successfully');
    }

    public function activeOrInactive($id)
    {
        $company_id = auth('company')->user()->company_id;
        $user = UserCompany::where('company_id', $company_id)->where('id', $id)->first();
        if(!$user){
            return $this->apiResponse([],self::STATUS_NOT_FOUND,'not found');
        }
        $user->is_active = !$user->is_active;
        $user->save();
    }

    public function store(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'name' => 'required',
            'username' => 'required|unique:user_companies,username',
            'password' => 'required',
            'roles' => 'required|array'
        ]);
        if ($validate instanceof Response) return $validate;

        $company_id = auth('company')->user()->company_id;
        $user = UserCompany::create([
            'name' => $request->name,
            'username' => $request->username,
            'password' => Hash::make($request->password),
            'company_id' => $company_id,
        ]);
        $user->roles()->attach($request->roles);
        // foreach ($request->roles as $role_id) {
        //     $data = [
        //         'company_permission_id' => $role_id,
        //         'user_company_id' => $user->id,
        //     ];
        //     // DB::table('user_companies_company_permission')->insert($data);
        // }
        return $this->apiResponse([], self::STATUS_OK, 'add successfully');
    }
    public function update(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'name' => 'required',
            'username' => 'required|unique:user_companies,username,' . $request->id,
            'roles' => 'required|array'
        ]);
        if ($validate instanceof Response) return $validate;

        $company_id = auth('company')->user()->company_id;
        $user = UserCompany::where('company_id', $company_id)->where('id', $request->id)->first();
        if (!$user) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'the user does not found');
        }
        $user->name = $request->name;
        $user->username = $request->username;
        if ($request->password && $request->password !== "") {
            $user->password = Hash::make($request->password);
        }
        $user->save();
        $user->roles()->sync($request->roles);

        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }
    public function delete($id)
    {
        $company_id = auth('company')->user()->company_id;
        $check = UserCompany::where('id', $id)->where('company_id', $company_id)->first();
        if ($check) {
            $check->delete();
            return $this->apiResponse([], self::STATUS_OK, 'delete successfully');
        } else {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'you can not perform this action');
        }
    }
}
