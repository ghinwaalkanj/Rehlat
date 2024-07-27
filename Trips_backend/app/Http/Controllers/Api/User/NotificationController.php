<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Models\UserNotification;
use Illuminate\Http\Request;

class NotificationController extends ApiController
{
    public function index()
    {
        $user_id = auth()->user()->id;
        $notifications = UserNotification::where('user_id', $user_id)->orderBy('id', 'desc')->paginate();
        $notifications->withPath('https://rehlat.sy/backend/api/v1/notifications');
        return $this->apiResponse(['notifications' => $notifications], self::STATUS_OK, 'get successfully');
    }
}
