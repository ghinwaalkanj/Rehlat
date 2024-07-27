<?php

use App\Models\UserNotification;

function storeNotification($user_id, $data, $notification2,$type)
{
    $notification = new UserNotification();
    $notification->user_id = $user_id;
    $notification->data = $data;
    $notification->notification = $notification2;
    $notification->type = $type;
    $notification->save();
}


