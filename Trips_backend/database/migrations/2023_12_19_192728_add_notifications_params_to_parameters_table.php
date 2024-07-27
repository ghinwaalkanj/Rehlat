<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('parameters', function (Blueprint $table) {
            $table->string('paid_reservation_confirmation_en')->nullable();
            $table->string('temporary_reservation_confirmation_en')->nullable();
            $table->string('paid_reservation_cancel_en')->nullable();
            $table->string('temporary_reservation_cancel_en')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('parameters', function (Blueprint $table) {
            //
        });
    }
};
