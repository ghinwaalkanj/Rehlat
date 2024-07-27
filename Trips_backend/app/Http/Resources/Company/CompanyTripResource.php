<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyTripResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'unique_id' => $this->unique_id,
            'source' => $this->source_city->name_ar,
            'destination' => $this->destination_city->name_ar,
            'start_date' => $this->start_date,
            'is_cancel' => $this->is_cancel,
            'bus' => [
                'id' => $this->bus->id,
                'name' => $this->bus->name,
                'number_seat' => $this->bus->number_seat,
                'details' => $this->bus->details,
            ],
            'timer' => 5,
            'extra_time' => 3,
            'seats_leaft' => $this->seats_leaft,
        ];
    }
}
