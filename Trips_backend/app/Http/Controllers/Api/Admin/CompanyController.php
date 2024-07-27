<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\Admin\AdminCompanyInfoResource;
use App\Models\Company;
use App\Models\CompanyPermission;
use App\Models\UserCompany;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;

class CompanyController extends ApiController
{
    public function index()
    {
        $companies = Company::all();
        return $this->apiResponse(['companies' => AdminCompanyInfoResource::collection($companies)], self::STATUS_OK, 'get successfully');
    }
    public function getCompanyById($id)
    {
        $company = Company::find($id);
        return $this->apiResponse(['company' => [
            'id' => $company->id,
            'name_ar' => $company->name_ar,
            'name_en' => $company->name_en,
            'username' => $company->username,
        ]]);
    }

    public function store(Request $request)
    {
        $validate  = $this->apiValidation($request, [
            'name_ar' => 'required',
            'name_en' => 'required',
            'logo' => 'image|required',
            'username' => 'required|unique:companies,username',
            'password' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;

        $file = $request->file('logo');
        $filename = time() . '-' . $file->getClientOriginalName();
        $storagePath = public_path('companies-logos');
        $file->move($storagePath, $filename);

        $company = Company::create([
            'name_ar' => $request->name_ar,
            'name_en' => $request->name_en,
            'username' => $request->username,
            'password' => Hash::make($request->password),
            'logo' => $filename
        ]);

        $user_company = UserCompany::create([
            'name' => $request->name_ar,
            'username' => $request->username,
            'password' => Hash::make($request->password),
            'company_id' => $company->id,
        ]);
        $first_permission = CompanyPermission::first();
        $user_company->roles()->attach([$first_permission->id]);

        return $this->apiResponse([], self::STATUS_OK, 'create successfully');
    }
    public function update(Request $request, $id)
    {

        $validate  = $this->apiValidation($request, [
            'logo' => 'image|mimes:jpg,png,jpeg,gif,svg',
        ]);
        if ($validate instanceof Response) return $validate;

        $company = Company::find($id);
        // $company->update($request->except('logo', 'password'));
        if ($request->name_ar != null && $request->name_ar != "") {
            $company->name_ar = $request->name_ar;
        }
        if ($request->hasFile('logo')) {
            $file = $request->file('logo');
            $filename = time() . '-' . $file->getClientOriginalName();
            $storagePath = public_path('companies-logos');
            $file->move($storagePath, $filename);
            $company->logo = $filename;
        }
        if ($request->name_en != null && $request->name_en != "") {
            $company->name_en = $request->name_en;
        }
        if ($request->username != null && $request->username != "") {
            $company->username = $request->username;
            $first_account = UserCompany::where('company_id', $company->id)->first();
            $first_account->username = $request->username;
            $first_account->save();
        }
        if ($request->password != null && $request->password != "") {
            $first_account = UserCompany::where('company_id', $company->id)->first();
            $first_account->password = Hash::make($request->password);
            $first_account->save();
        }
        $company->save();

        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }
}
