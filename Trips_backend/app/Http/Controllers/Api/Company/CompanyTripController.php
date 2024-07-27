<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\Company\CompanyReservationUserResource;
use App\Http\Resources\Company\CompanyTripInfoResource;
use App\Http\Resources\Company\CompanyTripResource;

use App\Models\Company;
use App\Models\Reservation;
use App\Models\Trip;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Date;

class CompanyTripController extends ApiController
{
    public function index()
    {
        $company = auth('company')->user();
        $trips = Trip::where('company_id', $company->company_id)->where('start_date', '>=', Carbon::now())
            ->where('start_date', '<', Carbon::now()->addDays(15))->get();
        return response()->json([
            'data' => CompanyTripResource::collection($trips)
        ]);
    }
    public function search(Request $request)
    {

        $query = Trip::query();

        // Check if source_city_id is provided in the request
        if ($request->has('source_city_id') && $request->source_city_id != null) {
            $sourceCityId = $request->input('source_city_id');
            $query->where('source_city_id', $sourceCityId);
        }

        // Check if destination_city_id is provided in the request
        if ($request->has('destination_city_id') && $request->destination_city_id != null) {
            $destinationCityId = $request->input('destination_city_id');
            $query->where('destination_city_id', $destinationCityId);
        }

        // Check if tripNumber is provided in the request
        if ($request->has('tripNumber') && $request->tripNumber != null) {
            $tripNumber = $request->input('tripNumber');
            $query->where('unique_id', 'LIKE', "%$tripNumber%");
        }

        // Check if dateTime is provided in the request
        if ($request->has('dateTime') && $request->dateTime != null) {
            $dateTime = $request->input('dateTime');
            // $query->Where('start_date', 'LIKE', "%$dateTime%");
            $parsedDate = Carbon::parse($dateTime)->format('Y-m-d');

            $query->whereDate('start_date', $parsedDate);
        }

        // Execute the query and get the results
        $company_id = auth('company')->user()->company_id;
        $results = $query->where('company_id', $company_id)->get();

        return response()->json(['results' => CompanyTripResource::collection($results)]);
    }
    public function searchForReservation(Request $request)
    {
        $query = Reservation::query();
        if ($request->has('phoneNumber') && $request->phoneNumber != null) {
            $phoneNumber = $request->input('phoneNumber');
            $query->where('phone', 'LIKE', "%$phoneNumber%");
        }

        if ($request->has('reservationNumber') && !empty($request->reservationNumber)) {
            $reservationNumber = $request->input('reservationNumber');
            $query->where('unique_id', 'LIKE', "%$reservationNumber%");
        }
        $company_id = auth('company')->user()->company_id;
        $results = $query->where('company_id', $company_id)
            ->whereHas('trip', function ($tripQuery) {
                $tripQuery->where('start_date', '>=', Carbon::today());
            })
            ->get();
        return $this->apiResponse(['reservations' => CompanyReservationUserResource::collection($results)]);
        // return response()->json(['results' => CompanyTripResource::collection($results)]);
    }

    public function update(Request $request, $id)
    {
        $company_id = auth('company')->user()->company_id;
        $trip = Trip::where([['company_id', $company_id], ['id', $id]])->first();
        $data = $request->all();
        $data['start_date'] = Carbon::parse($request->start_date);
        $trip->update($data);
        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }

    public function getTripInfo($id)
    {
        $company_id = auth('company')->user()->company_id;
        $trip = Trip::where([['company_id', $company_id], ['id', $id]])->first();
        return $this->apiResponse(['trip' => new CompanyTripInfoResource($trip)], self::STATUS_OK, 'get info successfully');
    }
    public function cancelTrip($id)
    {
        $company_id = auth('company')->user()->company_id;
        $trip = Trip::where('company_id', $company_id)->where('id', $id)->first();
        if (!$trip) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'can not perform this action');
        }
        $reservationCount = $trip->reservations()->count();
        if ($reservationCount > 0) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'لايمكن انهاء هذه الرحلة ,يوجد حجوزات بداخلها');
        }

        $trip->is_cancel = true;
        $trip->save();
        //! return paid
        $reservations = $trip->reservations;
        foreach ($reservations as $reservation) {
            $reservation->is_cancel = true;
            $reservation->save();
        }
        return $this->apiResponse([], self::STATUS_OK, 'cancel successfully');
    }


    public function addTripForList(Request $request)
    {
        $validate = $this->apiValidation($request, [
            'source_city_id' => 'required',
            'destination_city_id' => 'required',
            'start_date' => 'required|date',
            'bus_type' => 'required|in:normal,vip,small',
            'ticket_price' => 'required',
            'recursive' => 'required|array'

        ]);
        // $trip_id = Trip::insertGetId([
        //     'company_id' => 1,
        //     'source_city_id' => 2,
        //     'destination_city_id' => 3,
        //     'start_date' => new DateTime(),
        //     'number_of_seats' => 45,
        //     'ticket_price' => 5000,
        //     'seats_leaft' => 45,
        //     'bus_type' => 'normal',
        //     'rate' => 4.3
        // ]);
    }
}
