<?php

namespace App\Http\Resources;

use App\Models\Parameter;
use App\Models\Rate;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TripResource extends JsonResource
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

        $params = Parameter::first();
        $rate = 5.0;
        if ($this->serial_trip) {
            $rates = Rate::where('serial_trip', $this->serial_trip)->get();
            $sum = $rates->sum('rate');
            if ((int) $sum != 0) {
                $rate = $sum / count($rates);
            }
        }

        return [
            'id' => $this->id,
            'company' => [
                'id' => $this->company->id,
                'name' => $companyName,
                'logo' => url('backend/companies-logos/' . $this->company->logo),
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
            'number_of_seats' => $this->number_of_seats,
            'ticket_price' => $this->ticket_price + $this->ticket_price * ($this->percentage_price / 100),
            'seats_leaft' => $this->seats_leaft,
            'bus' => [
                'id' => $this->bus->id,
                'name' => $this->bus->name,
                'number_seat' => $this->bus->number_seat,
                'details' => $this->bus->details,
            ],
            'trip_number' => $this->unique_id,
            'rate' => $rate,
            'timer' => $params->timer ?? 5,
            'extra_time' => $params->extra_time ?? 3,
        ];
    }
}
