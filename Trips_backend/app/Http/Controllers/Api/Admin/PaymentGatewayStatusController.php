<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\PaymentGatewayStatus;
use Illuminate\Http\Request;

class PaymentGatewayStatusController extends ApiController
{
    public function index()
    {
        $payments = PaymentGatewayStatus::first();
        return $this->apiResponse(['status' => $payments], self::STATUS_OK, 'get successfully');
    }

    public function update(Request $request)
    {
        $payments = PaymentGatewayStatus::first();
        $payments->update($request->all());
        return $this->apiResponse([],self::STATUS_OK,'update successfully'); 
    }
}
