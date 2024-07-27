<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Controller;
use App\Http\Resources\CompanyInfoResource;
use App\Models\Company;
use Illuminate\Http\Request;

class CompanyController extends ApiController
{
    public function index()
    {
        $companies = Company::select('id', 'name_ar', 'name_en', 'logo')->get();
        return $this->apiResponse(['companies' => CompanyInfoResource::collection($companies)], self::STATUS_OK, 'get companies successfully');
    }
}
