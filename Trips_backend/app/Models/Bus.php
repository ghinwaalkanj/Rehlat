<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Bus extends Model
{
    use HasFactory;
    // use SoftDeletes;
    protected $guarded = [];
    

    protected $appends = ['details'];

    public function getDetailsAttribute()
    {
        return $this->name . " " . $this->number_seat;
    }
}
