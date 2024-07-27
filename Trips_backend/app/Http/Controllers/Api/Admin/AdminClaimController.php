<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\Claim;
use Illuminate\Http\Request;

class AdminClaimController extends ApiController
{
    public function index()
    {
        $claims = Claim::orderBy('id', 'desc')->paginate();
        return $this->apiResponse(['claims' => $claims], self::STATUS_OK, 'get successfully');
    }

    public function changeStatus(Request $request)
    {
        $claim = Claim::findOrFail($request->id);
        $claim->status = $request->status;
        $claim->save();
        return $this->apiResponse([], self::STATUS_OK, 'success');
    }
    public function answer(Request $request)
    {
        $claim = Claim::findOrFail($request->id);
        $claim->answer = $request->answer;
        $claim->save();
        return $this->apiResponse([], self::STATUS_OK, 'success');
    }
}
