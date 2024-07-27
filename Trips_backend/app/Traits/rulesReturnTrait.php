<?php

namespace App\Traits;

use PhpParser\Builder\Trait_;

trait rulesReturnTrait
{

    // Start lawyer Form Rules
    public function lawyerRegisterRules()
    {

        return [

            'full_name' => 'required|string|max:50',
            'phone' => 'required|string|max:50',
            'password' => 'required|string|min:8|confirmed',
            'is_agreed' => 'required|boolean|in:1',

        ];
    }
    public function lawyerLoginRules()
    {
        return [
            'phone' => 'required|string',
            'password' => 'required|string'
        ];
    }
    // End lawyer Form Rules


}
