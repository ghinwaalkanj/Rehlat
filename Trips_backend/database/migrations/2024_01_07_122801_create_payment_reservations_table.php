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
        Schema::create('payment_reservations', function (Blueprint $table) {
            $table->id();
            $table->string('phone');
            $table->unsignedBigInteger('company_id');
            $table->integer('price');
            $table->boolean('is_temp_from_app');
            $table->boolean('is_confirm_by_center');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payment_reservations');
    }
};
