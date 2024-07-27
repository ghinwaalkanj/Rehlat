<?php

namespace App\Http\Resources\Company;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserCompanyResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $roles = [];
        $roles_ar = [];
        $roles_ids = [];
        if ($this->roles) {
            foreach ($this->roles as $role) {
                array_push($roles, $role->name_en);
                array_push($roles_ar, $role->name_ar);
                array_push($roles_ids, $role->id);
            }
        }
        return [
            'id' => $this->id,
            'name' => $this->name,
            'username' => $this->username,
            'permissions' => $roles,
            'roles' => $roles_ar,
            'roles_ids' => $roles_ids,
            'is_active' => $this->is_active
        ];
    }
}
