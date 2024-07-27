<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Parameter;
use Illuminate\Http\Request;

class ParameterController extends ApiController
{
    public function index()
    {
        $parameters = Parameter::first();
        return $this->apiResponse(['params' => $parameters], self::STATUS_OK, 'success');
    }
    public function update(Request $request)
    {
        $params = Parameter::first();
        if (!$params) {
            $params = Parameter::create([]);
        }
        $params->update($request->all());
        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }
    
}
