<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\City;
use App\Models\Parameter;
use Illuminate\Http\Request;

class CityController extends ApiController
{
    public function create(Request $request)
    {
        City::create([
            'name_ar' => $request->name_ar,
            'name_en' => $request->name_en,
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'store successfully');
    }
    public function index()
    {
        $cities = City::all();
        return $this->apiResponse(['cities' => $cities, 'limit_passenger' => Parameter::first()->max_reservation], self::STATUS_OK, 'get cities successfully');
    }
}
