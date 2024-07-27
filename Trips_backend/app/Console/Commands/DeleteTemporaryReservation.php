<?php

namespace App\Console\Commands;

use App\Models\CancelReservation;
use App\Models\Parameter;
use App\Models\Reservation;
use App\Models\Trip;
use App\Models\User;
use App\Notifications\SendPushNotification;
use Carbon\Carbon;
use Illuminate\Console\Command;

class DeleteTemporaryReservation extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:delete-temporary-reservation';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $reservations = Reservation::all();


        function sendNotification($user_id, $trip_id, $reservation, $params)
        {
            $user = User::find($user_id);

            $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";
            $data_notification = [
                'trip_id' => $trip_id,
            ];


            $startDateTime = Carbon::parse($reservation->trip->start_date);
            $data_notification = [
                'trip_id' => $reservation->trip->id,
            ];
            $title = $user->lang == 'ar' ? "رحلات" : "Rehlat";


            $sourceCityName = $reservation->trip->source_city->getNameInLanguage($user->lang);
            $destinationCityName = $reservation->trip->destination_city->getNameInLanguage($user->lang);
            $date_trip =  Carbon::parse($reservation->trip->start_date)->toDateString();
            $timeSeparated = $startDateTime->format('g:i a');

            $message_notification = $user->lang == 'ar' ? " $params->temporary_reservation_cancel  من $sourceCityName إلى $destinationCityName بتاريخ $date_trip الساعة $timeSeparated "
                :  $params->temporary_reservation_cancel_en . "from" . $sourceCityName . " to " . $destinationCityName .  $date_trip . " at " . $timeSeparated;
            $user->notify(new SendPushNotification($title, $message_notification, $user->fcm_token, $data_notification, $user->id, 'reservation_temporary'));
            return;
        }
        foreach ($reservations as $reservation) {
            if ($reservation->seats[0]->status !== 'temporary')
                continue;
            $now = Carbon::now();
            $start_date = Carbon::parse($reservation->trip->start_date);
            $reservation_date = Carbon::parse($reservation->created_at);
            $remaining_time_to_trip = $now->diffInHours($start_date);

            if ($reservation_date->diffInHours($now) >= 6  && $remaining_time_to_trip < 48) {
                $seats = $reservation->seats;
                foreach ($seats as $index => $seat) {
                    $seat->update([
                        'status' => 'available',
                        'name' => null,
                        'is_selected' => false,
                        'selected_user_id' => null,
                        'age' => null,
                        'gender' => null,
                        'reservation_id' => null
                    ]);
                }
                $trip = Trip::find($reservation->trip_id);
                $trip->seats_leaft = $trip->seats_leaft + count($seats);
                $trip->save();
                $params = Parameter::first();
                sendNotification($reservation->user_id, $trip->id, $reservation, $params);

                CancelReservation::create([
                    'count_seats' => count($seats),
                    // 'amount' => $reservation->trip->ticket_price + $reservation->trip->ticket_price * ($reservation->trip->percentage_price / 100) * count($reservation->seats),
                    'amount' =>   count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100))),
                    'is_confirmed' => false,
                    'user_id' => $reservation->user_id,
                    'trip_id' => $trip->id,
                    'company_id' => $trip->company_id,
                    'date' => $trip->start_date,
                ]);

                $reservation->delete();
            } else if ($reservation_date->diffInHours($now) >= 3  && $remaining_time_to_trip < 24) {
                $seats = $reservation->seats;
                foreach ($seats as $index => $seat) {
                    $seat->update([
                        'status' => 'available',
                        'name' => null,
                        'is_selected' => false,
                        'selected_user_id' => null,
                        'age' => null,
                        'gender' => null,
                        'reservation_id' => null
                    ]);
                }
                $trip = Trip::find($reservation->trip_id);
                $trip->seats_leaft = $trip->seats_leaft + count($seats);
                $trip->save();
                $params = Parameter::first();
                sendNotification($reservation->user_id, $trip->id, $reservation, $params);

                CancelReservation::create([
                    'count_seats' => count($seats),
                    'amount' =>   count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100))),
                    'is_confirmed' => false,
                    'user_id' => $reservation->user_id,
                    'trip_id' => $trip->id,
                    'company_id' => $trip->company_id,
                    'date' => $trip->start_date,
                ]);
                $reservation->delete();
            } else if ($reservation_date->diffInHours($now) >= 1  && $remaining_time_to_trip < 12) {
                $seats = $reservation->seats;
                foreach ($seats as $index => $seat) {
                    $seat->update([
                        'status' => 'available',
                        'name' => null,
                        'is_selected' => false,
                        'selected_user_id' => null,
                        'age' => null,
                        'gender' => null,
                        'reservation_id' => null
                    ]);
                }
                $trip = Trip::find($reservation->trip_id);
                $trip->seats_leaft = $trip->seats_leaft + count($seats);
                $trip->save();
                $params = Parameter::first();
                sendNotification($reservation->user_id, $trip->id, $reservation, $params);
                CancelReservation::create([
                    'count_seats' => count($seats),
                    'amount' =>   count($reservation->seats) * ($trip->ticket_price + ($trip->ticket_price * ($trip->percentage_price / 100))),
                    'is_confirmed' => false,
                    'user_id' => $reservation->user_id,
                    'company_id' => $trip->company_id,
                    'trip_id' => $trip->id,
                    'date' => $trip->start_date,
                ]);
                $reservation->delete();
            }
        }
    }
}
