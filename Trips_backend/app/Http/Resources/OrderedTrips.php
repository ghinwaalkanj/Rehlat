<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderedTrips extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->details->id,
            'company' => $this->details->company->name_ar,
            'source' => $this->details->source_city->name_ar,
            'destination' => $this->details->destination_city->name_ar,
            'bus' => $this->details->bus->name,
            'rate' => $this->details->rate,
            'start_date' => $this->details->start_date,
        ];
    }
}
