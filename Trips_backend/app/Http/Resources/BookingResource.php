<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $lang = app()->getLocale();
        $companyName = $this->trip->company->getNameInLanguage($lang);
        $sourceCityName = $this->trip->source_city->getNameInLanguage($lang);
        $destinationCityName = $this->trip->destination_city->getNameInLanguage($lang);
        return [
            'id' => $this->id,
            'trip_id' => $this->trip->id,
            'company' => [
                'id' => $this->trip->company->id,
                'name' => $companyName,
                'logo' => $this->trip->company->logo,
            ],
            'source_city' => [
                'id' => $this->trip->source_city->id,
                'name' => $sourceCityName,
            ],
            'destination_city' => [
                'id' => $this->trip->destination_city->id,
                'name' => $destinationCityName,
            ],
            'start_date' => $this->trip->start_date,
            'reservation_number' => $this->unique_id,
            'number_of_seats' => $this->trip->number_of_seats,
            'ticket_price' => $this->trip->ticket_price +  $this->trip->ticket_price * ($this->trip->percentage_price / 100),
            'seats_leaft' => $this->trip->seats_leaft,
            'bus' => [
                'id' => $this->trip->bus->id,
                'name' => $this->trip->bus->name,
                'number_seat' => $this->trip->bus->number_seat,
                'details' => $this->trip->bus->details,
            ],
            'rate' => $this->trip->rate ?? 4.2,
            'my_seats' =>  SeatResource::collection($this->seats),
        ];
    }
}
