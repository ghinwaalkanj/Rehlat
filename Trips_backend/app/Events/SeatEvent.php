<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class SeatEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $seat_id;
    public $seat_status;
    public $trip_id;
    public $source;
    /**
     * Create a new event instance.
     */
    public function __construct($seat_id, $seat_status, $trip_id, $source)
    {
        $this->seat_id = $seat_id;
        $this->seat_status = $seat_status;
        $this->trip_id = $trip_id;
        $this->source = $source;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return [
            // new PrivateChannel('channel-name'),
            new Channel('trip.' . $this->trip_id)
        ];
    }

    public function broadcastWith()
    {
        // dd($this->message);
        return [
            'seat_id' => $this->seat_id,
            'seat_status' => $this->seat_status,
            'source' => $this->source,
        ];
    }
}
