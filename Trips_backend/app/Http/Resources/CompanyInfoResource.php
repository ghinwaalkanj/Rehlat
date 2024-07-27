<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CompanyInfoResource extends JsonResource
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
        return [
            'id' => $this->id,
            'logo' => url('backend/companies-logos/' . $this->logo),
            // 'logo' => url('companies-logos/' . $this->logo),
            'name' => $companyName,
        ];
    }
}
