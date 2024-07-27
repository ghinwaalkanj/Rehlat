<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Driver;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class DriverController extends ApiController
{
    public function index()
    {
        $company_id = auth('company')->user()->company_id;
        $drivers = Driver::where('company_id', $company_id)->get();
        return $this->apiResponse(['drivers' => $drivers], self::STATUS_OK, 'get successfully');
    }

    public function store(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'name' => 'required',
            'phone' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        $company_id = auth('company')->user()->company_id;
        Driver::create([
            'name' => $request->name,
            'phone' => $request->phone,
            'company_id' => $company_id,
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'created successfully');
    }

    public function update(Request $request)
    {
        $company_id = auth('company')->user()->company_id;
        $driver = Driver::where('company_id', $company_id)->where('id', $request->id)->first();
        if (!$driver) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'you can not perform this action');
        }
        $driver->update($request->all());
        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }

    public function delete($id)
    {
        $company_id = auth('company')->user()->company_id;
        $driver = Driver::where('company_id', $company_id)->where('id', $id)->first();
        if (!$driver) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'you can not perform this action');
        }
        $driver->delete();
        return $this->apiResponse([], self::STATUS_OK, 'delete successfully');
    }
}
