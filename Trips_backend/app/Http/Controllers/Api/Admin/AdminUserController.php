<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class AdminUserController extends ApiController
{
    public function getUsers()
    {
        $users = User::orderBy('id', 'desc')->paginate();
        return $this->apiResponse(['users' => $users], self::STATUS_OK, 'get successfully');
    }
    public function changeStatus(Request $request)
    {
        $user = User::findOrFail($request->id);
        $user->status = $request->status;
        $user->save();
        return $this->apiResponse([], self::STATUS_OK, 'success');
    }
    
}
