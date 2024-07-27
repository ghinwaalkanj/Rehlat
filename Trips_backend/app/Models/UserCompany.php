<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use PHPOpenSourceSaver\JWTAuth\Contracts\JWTSubject;

class UserCompany extends Authenticatable implements JWTSubject
{
    use HasFactory, HasApiTokens;
    protected $guarded = [];
    protected $hidden = ['password'];

    // public function getLogoAttribute($value)
    // {
    //     return url('backend/companies-logos/' . $value);
    // }

    public function roles(): BelongsToMany
    {

        return $this->belongsToMany(CompanyPermission::class, 'user_companies_company_permission');
    }

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        return [];
    }
}
