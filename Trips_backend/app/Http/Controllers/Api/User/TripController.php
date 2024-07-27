<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\TripInfoResource;
use App\Http\Resources\TripResource;
use App\Models\Trip;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\App;

class TripController extends ApiController
{
    public function search(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'date' => 'required|date',
            'source_id' => 'required',
            'destination_id' => 'required',

        ]);
        if ($validate instanceof Response) return $validate;

        $lang = App::getLocale();
        $trips = Trip::where('source_city_id', $request->source_id)
            ->where('destination_city_id', $request->destination_id)
            ->whereDate('start_date', $request->date)
            ->where('start_date', '>=', Carbon::now())
            ->where('seats_leaft', '>=', $request->passenger_num ?? 0)
            ->where('is_cancel', 0)
            ->get();
        return $this->apiResponse(['trips' => TripResource::collection($trips)], self::STATUS_OK, 'success');
    }

    public function getInfo($id)
    {
        $trip = Trip::findOrFail($id);
        return $this->apiResponse(['trip' => new TripInfoResource($trip)], self::STATUS_OK, 'success');
    }
}
