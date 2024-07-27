<?php

namespace App\Http\Resources\Company;

use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanySeatResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $is_selected = false;
        $selectedDateTime = $this->selected_date ? Carbon::parse($this->selected_date):false;
        if($selectedDateTime){
            $currentTime = Carbon::now();
            $currentTime = $currentTime->addHours(3);
            $differenceInMinutes = $currentTime->diffInMinutes($selectedDateTime);
            $is_selected =  $differenceInMinutes < 5 && $this->is_selected;
        }
        $selectedByMe = $is_selected && auth('company')->check() && auth('company')->user()->company_id == $this->selected_user_id && !$this->selected_by_user;        
        return [
            'id' => $this->id,
            'status' => $this->status,
            'number' => $this->number_seat,
            'is_selected' => $is_selected,
            'selected_by_me' => $selectedByMe
        ];
    }
}
