<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Claim;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ClaimController extends ApiController
{
    public function store(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'reservation_date' => 'required',
            'reservation_number' => 'required',
            'phone' => 'required',
            'message' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        $user_id = auth()->user()->id;
        $check = Reservation::where('unique_id', $request->reservation_number)->where('user_id', $user_id)->first();
        if (!$check) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, "يرجى التأكد من رقم الحجز");
        }
        Claim::create([
            'reservation_date' => $request->reservation_date,
            'reservation_number' => $request->reservation_number,
            'phone' => $request->phone,
            'message' => $request->message,
            'user_id' => $user_id
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'send claim successfully');
    }
    public function getClaims()
    {
        $user_id = auth()->user()->id;
        $claims = Claim::where('user_id', $user_id)->get();
        return $this->apiResponse(['claims' => $claims], self::STATUS_OK, 'get successfully');
    }
}
