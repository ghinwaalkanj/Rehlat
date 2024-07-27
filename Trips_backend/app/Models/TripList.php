<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TripList extends Model
{
    use HasFactory;
    protected $guarded = [];
    protected $casts = [
        'days' => 'json',
    ];
    public function bus()
    {
        return $this->belongsTo(Bus::class, 'bus_id');
    }
    public function source_city()
    {
        return $this->belongsTo(City::class, 'source_city_id');
    }

    public function destination_city()
    {
        return $this->belongsTo(City::class, 'destination_city_id');
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
