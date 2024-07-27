<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class City extends Model
{
    use HasFactory;
    protected $guarded = [];

    public function getNameInLanguage($language)
    {
        return $language === 'en' ? $this->name_en : $this->name_ar;
    }
    
}
