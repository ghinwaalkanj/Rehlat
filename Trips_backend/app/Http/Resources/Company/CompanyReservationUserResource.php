<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyReservationUserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $is_temporary = $this->seats[0]->status == 'temporary'?true:false;
        if($this->from_user){
            return [
                'id' => $this->id,
                'user' => [
                    'id' => $this->user->id,
                    'name' => $this->user->name,
                    'phone' => $this->user->phone,
                ],
                'is_temporary' =>$is_temporary,
                'unique_id' =>$this->unique_id,
                'seats' =>$this->seats,
                'ticket_price' => $this->trip->ticket_price + $this->trip->ticket_price * ($this->trip->percentage_price / 100),
            ];
        }
        return [
            'id' => $this->id,
            'user' =>null,
            'phone' => $this->phone,
            'is_temporary' =>$is_temporary,
            'unique_id' =>$this->unique_id,
            'seats' =>$this->seats,
        ];
    }
}
