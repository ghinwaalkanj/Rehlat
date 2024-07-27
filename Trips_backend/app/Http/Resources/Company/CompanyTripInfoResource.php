<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyTripInfoResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $lang = app()->getLocale();
        $companyName = $this->company->getNameInLanguage($lang);
        $sourceCityName = $this->source_city->getNameInLanguage($lang);
        $destinationCityName = $this->destination_city->getNameInLanguage($lang);
        return [
            'id' => $this->id,
            'company' => [
                'id' => $this->company->id,
                'name' => $companyName,
            ],
            'source_city' => [
                'id' => $this->source_city->id,
                'name' => $sourceCityName,
            ],
            'destination_city' => [
                'id' => $this->destination_city->id,
                'name' => $destinationCityName,
            ],
            'start_date' => $this->start_date,
            'is_cancel' => $this->is_cancel,
            'unique_id' => $this->unique_id,
            'number_of_seats' => $this->number_of_seats,
            'ticket_price' => $this->ticket_price,
            'seats_leaft' => $this->seats_leaft,
            'driver' => $this->driver->name ?? null,
            'assistant' => $this->assistant->name ??null,
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
            'seats' => CompanySeatResource::collection($this->seats),
        ];
    }
}
