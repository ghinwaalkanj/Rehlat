<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Kutia\Larafirebase\Facades\Larafirebase;
class SendPushNotification extends Notification
{
    use Queueable;

    protected $title;
    protected $message;
    protected $fcmTokens;
    protected $data;
    protected $type;
    protected $user_id;


    /**
     * Create a new notification instance.
     */
    public function __construct($title, $message, $fcmTokens, $data,$user_id, $type = null)
    {

        $this->title = $title;
        $this->message = $message;
        $this->fcmTokens = $fcmTokens;
        $this->data = $data;
        $this->type = $type;
        $this->user_id = $user_id;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['firebase'];
    }

    public function toFirebase($notifiable)
    {
        try{
            //store notification in database
        if ($this->user_id != 0) {
            $notification_store = [
                'title' => $this->title,
                'message' => $this->message,
            ];
            storeNotification($this->user_id, $this->data, $notification_store,$this->type);
        }
        //make notification display as popup when user close the app
        return Larafirebase::fromRaw([
            'registration_ids' => [$this->fcmTokens],
            'notification' => [
                'title' => $this->title,
                'body' => $this->message,
            ],
            'data' => $this->data,
        ])->send();
        }catch(\Exception $e){
            return $e->getMessage();
        }
        // $lawyer->notify(new SendPushNotification($title,$message_notification,$lawyer->fcm_token,$data_notification,$lawyer->id,'Event',0));  
    }
}
