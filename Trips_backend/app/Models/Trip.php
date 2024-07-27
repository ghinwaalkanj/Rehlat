<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trip extends Model
{
    use HasFactory;

    protected $guarded = [];


    public function bus()
    {
        return $this->belongsTo(Bus::class, 'bus_id');
    }
    public function driver()
    {
        return $this->belongsTo(Driver::class, 'driver_id');
    }
    public function assistant()
    {
        return $this->belongsTo(DriverAssistant::class, 'driver_assistant_id');
    }
    public function company()
    {
        return $this->belongsTo(Company::class, 'company_id');
    }

    public function source_city()
    {
        return $this->belongsTo(City::class, 'source_city_id');
    }

    public function destination_city()
    {
        return $this->belongsTo(City::class, 'destination_city_id');
    }

    public function reservations()
    {
        return $this->hasMany(Reservation::class, 'trip_id');
    }
    public function seats()
    {
        return $this->hasMany(Seat::class, 'trip_id');
    }


    public function scopeWithName($query, $lang)
    {
        return $query->select([
            'id', 'company_id', 'start_date', ($lang === 'en' ? 'name_en' : 'name_ar') . ' as name',
            'source_city_id', 'destination_city_id', 'number_of_seats', 'ticket_price', 'seats_leaft'
        ]);
    }

    public function getCreatedAtAttribute($value)
    {
        return Carbon::createFromTimestamp(strtotime($value))
            ->addHours(3)
            ->toDateTimeString();
    }
    public function setStartDateAttribute($value)
    {

        $new_date = Carbon::createFromTimestamp(strtotime($value))
            ->addHours(3)
            ->toDateTimeString();
        $this->attributes['start_date'] = $new_date;
    }
}
