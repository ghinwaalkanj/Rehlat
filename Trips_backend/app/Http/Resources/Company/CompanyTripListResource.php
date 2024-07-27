<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyTripListResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $lang = app()->getLocale();
        $sourceCityName = $this->source_city->getNameInLanguage($lang);
        $destinationCityName = $this->destination_city->getNameInLanguage($lang);
        return [
            'id' => $this->id,
            'source' => $sourceCityName,
            'destination' => $destinationCityName,
            'start_date' => $this->start_date,
            'unique_id' => $this->unique_id,
            'number_of_seats' => $this->number_of_seats,
            'ticket_price' => $this->ticket_price,
            'bus' => [
                'id' => $this->bus->id,
                'name' => $this->bus->name,
                'number_seat' => $this->bus->number_seat,
                'details' => $this->bus->details,
            ],
            'rate' => $this->rate ?? 4.5,
        ];
    }
}
