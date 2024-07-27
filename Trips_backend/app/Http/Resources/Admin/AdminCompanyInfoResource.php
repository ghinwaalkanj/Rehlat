<?php

namespace App\Http\Resources\Admin;

use App\Models\UserCompany;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AdminCompanyInfoResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $lang = app()->getLocale();
        $companyName = $this->getNameInLanguage($lang);
        $username = UserCompany::where('company_id',$this->id)->first();
        return [
            'id' => $this->id,
            'logo' => url('backend/companies-logos/' . $this->logo),
            // 'logo' => url('companies-logos/' . $this->logo),
            'name' => $companyName,
            'username' => $username->username,
        ];
    }
}
