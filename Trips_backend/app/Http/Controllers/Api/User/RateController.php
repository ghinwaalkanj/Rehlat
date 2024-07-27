<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\TripResource;
use App\Models\Rate;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;

class RateController extends ApiController
{
    public function checkRate()
    {
        $user = auth()->user();
        $rateIds = json_decode($user->rate_ids, true);
        if (count($rateIds) > 0) {
            $trip = Trip::whereIn('id', $rateIds)->whereDate('start_date', '<', Carbon::now()->subHours(2))
                ->orderBy('start_date', 'asc')->first();
            if (!$trip) {
                return $this->apiResponse([], self::STATUS_NOT_FOUND, 'not found reservations');
            }
            $valueToDelete = $trip->id;
            $users = User::where('id', $user->id)->whereJsonContains('rate_ids', $valueToDelete)->get();
            $updatedRateIds = array_filter($rateIds, function ($item) use ($valueToDelete) {
                return $item !== $valueToDelete;
            });

            $user->rate_ids = json_encode($updatedRateIds);
            /** @var \App\Models\User $user **/
            $user->save();

            return $this->apiResponse(['trip' => new TripResource($trip)], self::STATUS_OK, 'get trip successfully');
        } else {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'not found reservations');
        }
    }

    public function rateTrip(Request $request)
    {
        $validate  = $this->apiValidation($request, [
            'rate' => 'required',
            'trip_id' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        $user_id = auth()->user()->id;

        $trip = Trip::find($request->trip_id);
        Rate::create([
            'user_id' => $user_id,
            'rate' => $request->rate,
            'serial_trip' => $trip->serial_trip
        ]);
        return $this->apiResponse([], self::STATUS_OK, 'rate successfully');
    }
}
