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
        Schema::create('parameters', function (Blueprint $table) {
            $table->id();
            $table->integer('timer')->nullable();
            $table->integer('extra_time')->nullable();
            $table->string('paid_reservation_confirmation')->nullable();
            $table->string('temporary_reservation_confirmation')->nullable();
            $table->string('paid_reservation_cancel')->nullable();
            $table->string('temporary_reservation_cancel')->nullable();
            $table->integer('minute_try_otp')->nullable();
            $table->integer('max_requests')->nullable();
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('parameters');
    }
};
