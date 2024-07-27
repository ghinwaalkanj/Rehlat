<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyTripListInfoResource extends JsonResource
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
        // $bus_types = [
        //     'vip' => '1',
        //     'normal' => '2',
        //     'small' => '3',
        // ];
        return [
            'id' => $this->id,
            'days' => $this->days,
            'source' => $this->source_city->id,
            'destination' => $this->destination_city->id,
            'start_date' => $this->start_date,
            'unique_id' => $this->unique_id,
            'number_of_seats' => $this->number_of_seats,
            'ticket_price' => $this->ticket_price,
            'driver_id' => $this->driver_id,
            'driver_assistant_id' => $this->driver_assistant_id,
            'percentage_price' => $this->percentage_price,
            
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
