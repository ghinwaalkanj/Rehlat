<?php

namespace App\Http\Controllers\Api\Company;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\Company\CompanyTripListInfoResource;
use App\Http\Resources\Company\CompanyTripListResource;
use App\Http\Resources\Company\CompanyTripResource;
use App\Models\Bus;
use App\Models\Driver;
use App\Models\DriverAssistant;
use App\Models\Seat;
use App\Models\Trip;
use App\Models\TripList;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Str;

class TripListController extends ApiController
{

    public function index(Request $request)
    {

        $company_id = auth('company')->user()->company_id;
        $trip_list = TripList::where('company_id', $company_id)->get();
        return response()->json([
            'data' => CompanyTripListResource::collection($trip_list),
        ]);
    }

    public function getById($id)
    {
        $company_id = auth('company')->user()->company_id;
        $trip_list = TripList::where('id', $id)->where('company_id', $company_id)->first();
        return response()->json([
            'data' => new CompanyTripListInfoResource($trip_list),
        ]);
    }
    public function store(Request $request)
    {

        $validate = $this->apiValidation($request, [
            'source_city_id' => 'required',
            'destination_city_id' => 'required',
            'ticketPrice' => 'required',
            'percentage_price' => 'required',
            'bus_id' => 'required',
            'dateTime' => 'required',
            // 'daysOfWeek' => 'required',
        ]);

        if ($validate instanceof Response) return $validate;

        // $table->string('serial_trip');
        $randomString = Str::random(10);



        // $bus_types = [
        //     '1' => 'vip',
        //     '2' => 'normal',
        //     '3' => 'small',
        // ];
        // $bus_seats = [
        //     '1' => 33,
        //     '2' => 45,
        //     '3' => 29,
        // ];
        $company = auth('company')->user();
        $driver = Driver::where('company_id', $company->company_id)->where('id', $request->driver_id)->first();
        $driver_assistant = DriverAssistant::where('company_id', $company->company_id)->where('id', $request->driver_assistant_id)->first();
        if ((!is_null($request->driver_id) && !$driver) || (!is_null($request->driver_assistant_id) && !$driver_assistant)) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'error on driver or assistant');
        }
        // $formattedDatetime = Carbon::createFromFormat('Y-m-d H:i:s', $request->dateTime);
        $formattedDatetime = Carbon::parse($request->dateTime);
        $time = $formattedDatetime->format('H:i:s');
        $bus = Bus::find($request->bus_id);
        //* types : 1 for once , 2 choose the date , 3 unlimited
        if ($request->type == "once") {
            $startDate = Carbon::parse($request->input('start_date'));
            $dateTime = $startDate->toDateString() . ' ' . $time;
            $trip = Trip::create([
                'source_city_id' => $request->source_city_id,
                'unique_id' => random_int(1000000, 9999999),
                'destination_city_id' => $request->destination_city_id,
                'ticket_price' => $request->ticketPrice,
                'percentage_price' => $request->percentage_price,
                'bus_id' => $request->bus_id,
                'start_date' => $dateTime,
                'company_id' => $company->company_id,
                'rate' => 5.0,
                'number_of_seats' => $bus->number_seat,
                'seats_leaft' => $bus->number_seat,
                'serial_trip' => $randomString,
                'driver_id' => $request->driver_id,
                'driver_assistant_id' => $request->driver_assistant_id,
            ]);
            for ($i = 0; $i < $trip->number_of_seats; $i++) {
                Seat::create([
                    'trip_id' => $trip->id,
                    'number_seat' => $i + 1,
                ]);
            }
        }
        if ($request->type == "specificPeriod") {

            // Get the start date from the request
            $startDate = Carbon::parse($request->input('start_date'));

            // Get the end date from the request
            $endDate = Carbon::parse($request->input('end_date'));

            // Get the days from the request (e.g., [3] for Thursday)
            $days = $request->daysOfWeek;

            // Get the time from the request (e.g., '11:00')



            // Loop through the range of dates
            while ($startDate->lte($endDate)) {
                // Check if the current day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday) is in the $days array
                if (in_array($startDate->dayOfWeek, $days)) {
                    // Create a record with the current date and time
                    $dateTime = $startDate->toDateString() . ' ' . $time;
                   
                    $trip = Trip::create([
                        'source_city_id' => $request->source_city_id,
                        'unique_id' => random_int(1000000, 9999999),
                        'destination_city_id' => $request->destination_city_id,
                        'ticket_price' => $request->ticketPrice,
                        'percentage_price' => $request->percentage_price,
                        'bus_id' => $request->bus_id,
                        'start_date' => $dateTime,
                        'company_id' => $company->company_id,
                        'rate' => 5.0,
                        'number_of_seats' => $bus->number_seat,
                        'seats_leaft' => $bus->number_seat,
                        'serial_trip' => $randomString,
                        'driver_id' => $request->driver_id,
                        'driver_assistant_id' => $request->driver_assistant_id,
                    ]);

                    for ($i = 0; $i < $trip->number_of_seats; $i++) {
                        Seat::create([
                            'trip_id' => $trip->id,
                            'number_seat' => $i + 1,
                        ]);
                    }
                }

                // Increment $startDate for the next day
                $startDate->addDay();
            }
        }

        if ($request->type == 'unlimited') {
            TripList::create([
                'source_city_id' => $request->source_city_id,
                'destination_city_id' => $request->destination_city_id,
                'ticket_price' => $request->ticketPrice,
                'percentage_price' => $request->percentage_price,
                'bus_id' => $request->bus_id,
                'start_date' => $formattedDatetime,
                'days' => $request->daysOfWeek,
                'company_id' => $company->company_id,
                'rate' => 5.0,
                'number_of_seats' => $bus->number_seat,
                'seats_leaft' => $bus->number_seat,
                'serial_trip' => $randomString,
                'driver_id' => $request->driver_id,
                'driver_assistant_id' => $request->driver_assistant_id,
            ]);

            $currentDate = Carbon::now();

            // Calculate the start date for the records (one day after the current date)
            $startDate = $currentDate->addDay();

            // Calculate the end date for the records (one month later)
            $endDate = $startDate->copy()->addMonth();

            // Get the days from the request (e.g., [3] for Thursday)
            $days = $request->daysOfWeek;

            // Get the time from the request (e.g., '11:00')
            // $time = $request->input('time');
            $test_array = [];
            // Loop through the range of dates
            while ($startDate->lte($endDate)) {
                // Check if the current day of the week (0 = Sunday, 1 = Monday, ..., 6 = Saturday) is in the $days array
                if (in_array($startDate->dayOfWeek + 1, $days)) {
                    // Create a record with the current date and time
                    $dateTime = $startDate->toDateString() . ' ' . $time;
                    array_push($test_array, $dateTime);
                    $trip = Trip::create([
                        'source_city_id' => $request->source_city_id,
                        'unique_id' => random_int(1000000, 9999999),
                        'destination_city_id' => $request->destination_city_id,
                        'ticket_price' => $request->ticketPrice,
                        'percentage_price' => $request->percentage_price,
                        'bus_id' => $request->bus_id,
                        'start_date' => $dateTime,
                        'company_id' => $company->company_id,
                        'rate' => 5.0,
                        'number_of_seats' => $bus->number_seat,
                        'seats_leaft' => $bus->number_seat,
                        'serial_trip' => $randomString,
                        'driver_id' => $request->driver_id,
                        'driver_assistant_id' => $request->driver_assistant_id,
                    ]);
                    for ($i = 0; $i < $trip->number_of_seats; $i++) {
                        Seat::create([
                            'trip_id' => $trip->id,
                            'number_seat' => $i + 1,
                        ]);
                    }
                }

                // Increment $startDate for the next day
                $startDate->addDay();
            }
        }





        return $this->apiResponse([], self::STATUS_OK, 'create successfully');
    }
    public function update(Request $request, $id)
    {
        $validate = $this->apiValidation($request, [
            'source_city_id' => 'required',
            'destination_city_id' => 'required',
            'ticket_price' => 'required',
            'percentage_price' => 'required',
            'bus_id' => 'required',
            'dateTime' => 'required',
            'daysOfWeek' => 'required',
        ]);
        if ($validate instanceof Response) return $validate;
        // $bus_types = [
        //     '1' => 'vip',
        //     '2' => 'normal',
        //     '3' => 'small',
        // ];
        // $bus_seats = [
        //     '1' => 33,
        //     '2' => 45,
        //     '3' => 29,
        // ];

        $bus = Bus::find($request->bus_id);
        $company_id = auth('company')->user()->company_id;

        $driver = Driver::where('company_id', $company_id)->where('id', $request->driver_id)->first();
        $driver_assistant = DriverAssistant::where('company_id', $company_id)->where('id', $request->driver_assistant_id)->first();
        if ((!is_null($request->driver_id) && !$driver) || (!is_null($request->driver_assistant_id) && !$driver_assistant)) {
            return $this->apiResponse([], self::STATUS_FORBIDDEN, 'error on driver or assistant');
        }


        $formattedDatetime = Carbon::parse($request->dateTime);
        $time = $formattedDatetime->format('H:i:s');
        $trip_list = TripList::where('company_id', $company_id)->where('id', $id)->first();
        if (!$trip_list) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'not found');
        }
        $trip_list->update([
            'source_city_id' => $request->source_city_id,
            'destination_city_id' => $request->destination_city_id,
            'ticket_price' => (int) $request->ticket_price,
            'percentage_price' => $request->percentage_price,
            'bus_id' => $request->bus_id,
            'start_date' => $formattedDatetime,
            'days' => $request->daysOfWeek,
            'number_of_seats' => $bus->number_seat,
            'seats_leaft' => $bus->number_seat,
            'driver_id' => $request->driver_id,
            'driver_assistant_id' => $request->driver_assistant_id,
        ]);

        $currentDate = Carbon::now();
        $startDate = $currentDate->addDay();
        $endDate = $startDate->copy()->addMonth();
        $days = $request->daysOfWeek;
        $test_array = [];
        // Loop through the range of dates

        $get_trips_for_delete = Trip::where('company_id', $company_id)
            ->where('serial_trip', $trip_list->serial_trip)
            ->where('start_date', '>', Carbon::now()->addHours(3))
            ->get();

        foreach ($get_trips_for_delete as $trip) {
            $check = $trip->reservations;
            if (count($check) > 0) {
                continue;
            }
            $trip->delete();
        }

        while ($startDate->lte($endDate)) {
            if (in_array($startDate->dayOfWeek + 1, $days)) {
                $dateTime = $startDate->toDateString() . ' ' . $time;
                array_push($test_array, $dateTime);
                $trip = Trip::create([
                    'source_city_id' => $request->source_city_id,
                    'unique_id' => random_int(1000000, 9999999),
                    'destination_city_id' => $request->destination_city_id,
                    'ticket_price' => $request->ticket_price,
                    'percentage_price' => $request->percentage_price,
                    'bus_id' => $request->bus_id,
                    'start_date' => $dateTime,
                    'company_id' => $company_id,
                    'rate' => 5.0,
                    'number_of_seats' => $bus->number_seat,
                    'seats_leaft' => $bus->number_seat,
                    'serial_trip' => $trip_list->serial_trip,
                    'driver_id' => $request->driver_id,
                    'driver_assistant_id' => $request->driver_assistant_id,
                ]);
                for ($i = 0; $i < $trip->number_of_seats; $i++) {
                    Seat::create([
                        'trip_id' => $trip->id,
                        'number_seat' => $i + 1,
                    ]);
                }
            }

            $startDate->addDay();
        }


        return $this->apiResponse([], self::STATUS_OK, 'update successfully');
    }
 
    public function delete($id)
    {
        $company_id = auth('company')->user()->company_id;
        $trip_list = TripList::where('company_id', $company_id)->where('id', $id)->first();
        if (!$trip_list) {
            return $this->apiResponse([], self::STATUS_NOT_FOUND, 'not found');
        }

        $get_trips_for_delete = Trip::where('company_id', $company_id)
            ->where('serial_trip', $trip_list->serial_trip)
            ->where('start_date', '>', Carbon::now()->addHours(3))
            ->get();

        foreach ($get_trips_for_delete as $trip) {
            $check = $trip->reservations;
            if (count($check) > 0) {
                continue;
            }
            $trip->delete();
        }
        $trip_list->delete();
        return $this->apiResponse([],self::STATUS_OK,'success');
    }
}
