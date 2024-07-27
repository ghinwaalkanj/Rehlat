<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class MatchingCountIdsWithPassengers implements ValidationRule
{


    private $passengers;

    public function __construct($passengers)
    {
        $this->passengers = $passengers;
    }

    /**
     * Run the validation rule.
     *
     * @param  \Closure(string): \Illuminate\Translation\PotentiallyTranslatedString  $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        //  $fail('the count passengers array must be valid ');
        if( !$this->passengers || count($value) !== count($this->passengers)){
            $fail('the count passengers array must be valid ');
        }

    }
}
