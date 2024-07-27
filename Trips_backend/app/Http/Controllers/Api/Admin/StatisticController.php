<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\OrderedTrips;
use App\Models\CancelReservation;
use App\Models\Company;
use App\Models\PaymentReservations;
use App\Models\Trip;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StatisticController extends ApiController
{
    public function forAdmin(Request $request)
    {
        $companies = Company::all();

        $mostOrderedTrips = Trip::select('serial_trip', DB::raw('COUNT(*) as reservations_count'))
            ->groupBy('serial_trip')
            ->orderByDesc('reservations_count')
            ->take(10)
            ->get();

        // Fetch details for each most ordered trip
        foreach ($mostOrderedTrips as $orderedTrip) {
            $details = Trip::where('serial_trip', $orderedTrip->serial_trip)->first();
            $orderedTrip->details = $details;
        }


        $collectionMostOrderedTrips = OrderedTrips::collection($mostOrderedTrips);

        $fewerOrderedTrips = Trip::select('serial_trip', DB::raw('COUNT(*) as reservations_count'))
            ->groupBy('serial_trip')
            ->orderBy('reservations_count')
            ->take(10)
            ->get();

        foreach ($fewerOrderedTrips as $orderedTrip) {
            $details = Trip::where('serial_trip', $orderedTrip->serial_trip)->first();
            $orderedTrip->details = $details;
        }


        $collectionFewerOrderedTrips = OrderedTrips::collection($fewerOrderedTrips);

        // $monyBackFromDeleteTrip = PaymentReservations::where('is_temp_from_app', true)
        //     ->where('is_confirm_by_center', true)
        //     ->where('phone', '39483')
        //     ->selectRaw('DATE(created_at) as day, SUM(price) as total_price')
        //     ->groupBy('day')
        //     ->get()
        //     ->keyBy('day')
        //     ->map(function ($item) {
        //         return ['monyBackFromDeleteTrip' => $item->total_price];
        //     });
        $monyBackFromDeleteTrip = CancelReservation::selectRaw('DATE(date) as day, SUM(amount) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['monyBackFromDeleteTrip' => $item->total_price];
            });

        $totalFromAppReservation = PaymentReservations::where('is_temp_from_app', false)
            ->where('is_confirm_by_center', false)
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['totalFromAppReservation' => $item->total_price];
            });

        $reservationTemporaryAndReserverCenter = PaymentReservations::where('is_temp_from_app', true)
            ->where('is_confirm_by_center', true)
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['reservationTemporaryAndReserverCenter' => $item->total_price];
            });

        $reserveFromCenter = PaymentReservations::where('is_temp_from_app', false)
            ->where('is_confirm_by_center', true)
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['reserveFromCenter' => $item->total_price];
            });

        $days = array_unique(
            array_merge(
                $monyBackFromDeleteTrip->keys()->toArray(),
                $totalFromAppReservation->keys()->toArray(),
                $reservationTemporaryAndReserverCenter->keys()->toArray(),
                $reserveFromCenter->keys()->toArray()
            )
        );

        $result = [];
        foreach ($days as $day) {
            $result[] = [
                'day' => $day,
                'monyBackFromDeleteTrip' => $monyBackFromDeleteTrip[$day]['monyBackFromDeleteTrip'] ?? 0,
                'totalFromAppReservation' => $totalFromAppReservation[$day]['totalFromAppReservation'] ?? 0,
                'reservationTemporaryAndReserverCenter' => $reservationTemporaryAndReserverCenter[$day]['reservationTemporaryAndReserverCenter'] ?? 0,
                'reserveFromCenter' => $reserveFromCenter[$day]['reserveFromCenter'] ?? 0,
            ];
        }


        return $this->apiResponse([
            'companies' => $companies,
            'mostOrderedTrips' => $collectionMostOrderedTrips,
            'fewerOrderedTrips' => $collectionFewerOrderedTrips,
            'result' => $result,
        ], self::STATUS_OK, 'get successfully');
    }

    public function forCompany()
    {
        $company_id = auth('company')->user()->company_id;

        $mostOrderedTrips = Trip::where('company_id', $company_id)
            ->select('serial_trip', DB::raw('COUNT(*) as reservations_count'))
            ->groupBy('serial_trip')
            ->orderByDesc('reservations_count')
            ->take(10)
            ->get();

        // Fetch details for each most ordered trip
        foreach ($mostOrderedTrips as $orderedTrip) {
            $details = Trip::where('serial_trip', $orderedTrip->serial_trip)->first();
            $orderedTrip->details = $details;
        }


        $collectionMostOrderedTrips = OrderedTrips::collection($mostOrderedTrips);

        $fewerOrderedTrips = Trip::where('company_id', $company_id)
            ->select('serial_trip', DB::raw('COUNT(*) as reservations_count'))
            ->groupBy('serial_trip')
            ->orderBy('reservations_count')
            ->take(10)
            ->get();

        foreach ($fewerOrderedTrips as $orderedTrip) {
            $details = Trip::where('serial_trip', $orderedTrip->serial_trip)->first();
            $orderedTrip->details = $details;
        }


        $collectionFewerOrderedTrips = OrderedTrips::collection($fewerOrderedTrips);

        // $monyBackFromDeleteTrip = PaymentReservations::where('company_id', $company_id)
        //     ->where('is_temp_from_app', true)
        //     ->where('is_confirm_by_center', true)
        //     ->where('phone', '39483')
        //     ->selectRaw('DATE(created_at) as day, SUM(price) as total_price')
        //     ->groupBy('day')
        //     ->get()
        //     ->keyBy('day')
        //     ->map(function ($item) {
        //         return ['monyBackFromDeleteTrip' => $item->total_price];
        //     });

        $monyBackFromDeleteTrip = CancelReservation::where('company_id', $company_id)
            ->selectRaw('DATE(date) as day, SUM(amount) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['monyBackFromDeleteTrip' => $item->total_price];
            });

        $totalFromAppReservation = PaymentReservations::where('company_id', $company_id)
            ->where('is_temp_from_app', false)
            ->where('is_confirm_by_center', false)
            // ->where('phone', '39483')
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['totalFromAppReservation' => $item->total_price];
            });

        $reservationTemporaryAndReserverCenter = PaymentReservations::where('company_id', $company_id)
            ->where('is_temp_from_app', true)
            ->where('is_confirm_by_center', true)
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['reservationTemporaryAndReserverCenter' => $item->total_price];
            });

        $reserveFromCenter = PaymentReservations::where('company_id', $company_id)
            ->where('is_temp_from_app', false)
            ->where('is_confirm_by_center', true)
            ->selectRaw('DATE(date) as day, SUM(price) as total_price')
            ->groupBy('day')
            ->get()
            ->keyBy('day')
            ->map(function ($item) {
                return ['reserveFromCenter' => $item->total_price];
            });

        $days = array_unique(
            array_merge(
                $monyBackFromDeleteTrip->keys()->toArray(),
                $totalFromAppReservation->keys()->toArray(),
                $reservationTemporaryAndReserverCenter->keys()->toArray(),
                $reserveFromCenter->keys()->toArray()
            )
        );

        $result = [];
        foreach ($days as $day) {
            $result[] = [
                'day' => $day,
                'monyBackFromDeleteTrip' => $monyBackFromDeleteTrip[$day]['monyBackFromDeleteTrip'] ?? 0,
                'totalFromAppReservation' => $totalFromAppReservation[$day]['totalFromAppReservation'] ?? 0,
                'reservationTemporaryAndReserverCenter' => $reservationTemporaryAndReserverCenter[$day]['reservationTemporaryAndReserverCenter'] ?? 0,
                'reserveFromCenter' => $reserveFromCenter[$day]['reserveFromCenter'] ?? 0,
            ];
        }


        return $this->apiResponse([

            'mostOrderedTrips' => $collectionMostOrderedTrips,
            'fewerOrderedTrips' => $collectionFewerOrderedTrips,
            'result' => $result,
        ], self::STATUS_OK, 'get successfully');
    }


    public function dashboardAdmin(Request $request)
    {
        $period = $request->input('period', 'month'); // Default to monthly period

        $currentDateTime = date('Y-m-d H:i:s');
        $now = Carbon::parse($currentDateTime, 'UTC');

        //! first section for day 
        $startDate = $now->copy()->startOfDay();
        $endDate = $now->copy()->endOfDay();
        $trips = Trip::whereBetween('start_date', [$startDate, $endDate])
            ->get();
        $tripCounts = $trips->count();

        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;

        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->endOfDay()])->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }

        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));;
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }


        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        $payments = PaymentReservations::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;

        
        $data_day =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,

        ];

        //! section for week
        $startDate = $now->copy()->startOfDay(); // Start of the current day
        $endDate = $now->copy()->addDays(7)->endOfDay(); // End of the day 7 days from now

        // $startDate = $now->copy()->subDays(7)->endOfDay(); // Start of the current day
        // $endDate = $now->copy()->startOfDay();

        $trips = Trip::whereBetween('start_date', [$startDate, $endDate])
            ->get();
        $tripCounts = $trips->count();

        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;

        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(7)->endOfDay()])->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }

        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));;
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }


        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        $payments = PaymentReservations::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(7)->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;


        $data_week =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,
        ];

        //! section for month
        $startDate = $now->copy()->startOfDay(); // Start of the current day
        $endDate = $now->copy()->addDays(30)->endOfDay(); // End of the day 7 days from now

        // $startDate = $now->copy()->subDays(30)->endOfDay(); // Start of the current day
        // $endDate = $now->copy()->startOfDay();

        $trips = Trip::whereBetween('start_date', [$startDate, $endDate])
            ->get();


        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(30)->endOfDay()])->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }

        $tripCounts = $trips->count();
        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;
        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));;
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }


        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        $payments = PaymentReservations::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(30)->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;


        $data_month =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,
        ];


        return response()->json([
            'day' => $data_day,
            'week' => $data_week,
            'month' => $data_month
        ]);
    }

    public function dashboardCompany(Request $request)
    {
        $period = $request->input('period', 'month'); // Default to monthly period

        $currentDateTime = date('Y-m-d H:i:s');
        $now = Carbon::parse($currentDateTime, 'UTC');

        // Get the start of the day
        // $startOfDay = $carbonDateTime->copy()->startOfDay();

        // Get the end of the day
        // $endOfDay = $carbonDateTime->copy()->endOfDay();
        // return [
        //     "now" => $carbonDateTime,
        //     "startOfDay" => $carbonDateTime->copy()->startOfDay(),
        //     "endOf" => $carbonDateTime->copy()->endOfDay(),
        // ];
        // return $now = Carbon::now();
        // return $now->copy()->startOfDay();
        //! first section for day 
        $startDate = $now->copy()->startOfDay();
        $endDate = $now->copy()->endOfDay();
        $trips = Trip::where('company_id', auth('company')->user()->company_id)->whereBetween('start_date', [$startDate, $endDate])
            ->get();
        $tripCounts = $trips->count();

        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->endOfDay()])
            ->where('company_id', auth('company')->user()->company_id)->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }

        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;
        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));;
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }


        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        // return [$now->copy()->startOfDay(), $now->copy()->endOfDay()];
        $payments = PaymentReservations::where('company_id', auth('company')->user()->company_id)->whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;


        $data_day =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,
        ];

        //! section for week
        $startDate = $now->copy()->startOfDay(); // Start of the current day
        $endDate = $now->copy()->addDays(7)->endOfDay(); // End of the day 7 days from now
        // $startDate = $now->copy()->subDays(7)->endOfDay(); // Start of the current day
        // $endDate = $now->copy()->startOfDay();
        $trips = Trip::where('company_id', auth('company')->user()->company_id)->whereBetween('start_date', [$startDate, $endDate])
            ->with('reservations.seats')->get();

        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(7)->endOfDay()])
            ->where('company_id', auth('company')->user()->company_id)->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }
        $tripCounts = $trips->count();
        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;
        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        // return $trips;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            $test_seats = [];
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }

        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        $payments = PaymentReservations::where('company_id', auth('company')->user()->company_id)->whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(7)->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;


        $data_week =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,
        ];

        //! section for month
        $startDate = $now->copy()->startOfDay(); // Start of the current day
        $endDate = $now->copy()->addDays(30)->endOfDay(); // End of the day 7 days from now

        // $startDate = $now->copy()->subDays(30)->endOfDay(); // Start of the current day
        // $endDate = $now->copy()->startOfDay();

        $trips = Trip::where('company_id', auth('company')->user()->company_id)->whereBetween('start_date', [$startDate, $endDate])
            ->get();
        $count_seats_canceled = 0;
        $value_of_seats_canceled = 0;
        $canceled_seats = CancelReservation::whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(30)->endOfDay()])
            ->where('company_id', auth('company')->user()->company_id)->get();

        foreach ($canceled_seats as $canceled) {
            $count_seats_canceled = $count_seats_canceled + $canceled->count_seats;
            if ($canceled->is_confirmed) {
                $value_of_seats_canceled = $value_of_seats_canceled + $canceled->amount;
            }
        }
        $tripCounts = $trips->count();
        $count_temporary_seat = 0;
        $count_confirmed_seat = 0;
        $count_reservation = 0;
        $count_temporary_reservation = 0;
        $count_sticky_reservation = 0;
        $count_seats = 0;
        $count_reservation_seats = 0;
        $count_available_seats = 0;
        $count_unavailable_seats = 0;
        $price_of_temporary_reservation = 0;
        foreach ($trips as $trip) {

            $count_seats = $count_seats + count($trip->seats);
            foreach ($trip->reservations as $reservation) {
                $count_unavailable_seats = $count_unavailable_seats + count($reservation->seats);
                if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'temporary') {
                    $count_temporary_seat = $count_temporary_seat + count($reservation->seats);
                    $count_temporary_reservation++;
                    $price_of_temporary_reservation =
                        $price_of_temporary_reservation +
                        // count($reservation->seats) * $trip->ticket_price * $trip->percentage_price;
                        count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100)));
                } else if ($reservation && count($reservation->seats) > 0 && $reservation->seats[0]["status"] === 'unavailable') {
                    $count_confirmed_seat = $count_confirmed_seat + count($reservation->seats);
                    $count_sticky_reservation++;
                }
                $count_reservation++;
            }
        }


        $allPaymentValue = 0;
        $payment_via_app = 0;
        $payment_from_app_and_office = 0;
        $payment_from_office = 0;
        $payments = PaymentReservations::where('company_id', auth('company')->user()->company_id)->whereBetween('date', [$now->copy()->startOfDay(), $now->copy()->addDays(30)->endOfDay()])
            ->get();

        foreach ($payments as $payment) {
            $allPaymentValue = $allPaymentValue + $payment->price;
            if (!$payment->is_temp_from_app && !$payment->is_confirm_by_center) {
                $payment_via_app = $payment_via_app + $payment->price;
            }
            if ($payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_app_and_office = $payment_from_app_and_office + $payment->price;
            }
            if (!$payment->is_temp_from_app && $payment->is_confirm_by_center) {
                $payment_from_office = $payment_from_office + $payment->price;
            }
        }

        $price_of_confirmed_reservation = 0;


        $data_month =  [
            'trip_counts' => $tripCounts,
            'count_reservation' => $count_reservation,
            "count_temporary_reservation" => $count_temporary_reservation,
            'count_sticky_reservation' => $count_sticky_reservation,
            'count_seats' => $count_seats,
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'count_temporary_seat' => $count_temporary_seat,
            'count_confirmed_seat' => $count_confirmed_seat,
            'count_seats_canceled' => $count_seats_canceled,
            'value_of_seats_canceled' => $value_of_seats_canceled,
            // section two
            'price_of_all_reservation' => $allPaymentValue + $price_of_temporary_reservation,
            'price_of_temporary_reservation' => $price_of_temporary_reservation,
            'price_of_confirmed_reservation' => $allPaymentValue,
            // section three
            'count_available_seats' => $count_seats - $count_temporary_seat - $count_confirmed_seat,
            'all_payments' => $allPaymentValue,
            'payment_via_app' => $payment_via_app,
            'payment_from_app_and_office' => $payment_from_app_and_office,
            'payment_from_office' => $payment_from_office,
        ];


        return response()->json([
            'day' => $data_day,
            'week' => $data_week,
            'month' => $data_month
        ]);
    }
}
