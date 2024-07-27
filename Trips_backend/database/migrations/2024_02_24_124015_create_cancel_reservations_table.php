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
        Schema::create('cancel_reservations', function (Blueprint $table) {
            $table->id();
            $table->integer('count_seats');
            $table->integer('amount');
            $table->boolean('is_confirmed');
            $table->unsignedBigInteger('user_id')->nullable();
            $table->unsignedBigInteger('trip_id')->nullable();
            $table->foreign('user_id')->references('id')->on('users')
                ->onDelete('set null');
            $table->foreign('trip_id')->references('id')->on('trips')
                ->onDelete('set null');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cancel_reservations');
    }
};
