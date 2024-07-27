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
        Schema::create('trip_lists', function (Blueprint $table) {
            $table->id();
            $table->json('days');
            $table->unsignedBigInteger('company_id');
            $table->unsignedBigInteger('source_city_id');
            $table->unsignedBigInteger('destination_city_id');
            // $table->enum('bus_type', ['vip', 'normal', 'small']);
            $table->unsignedBigInteger('bus_id');
            $table->foreign('bus_id')->references('id')
                ->on('buses')->onDelete('cascade')->onDelete('cascade');
            $table->double('rate');
            $table->dateTime('start_date');
            $table->integer('number_of_seats');
            $table->integer('ticket_price');
            $table->integer('seats_leaft')->nullable();
            $table->string('serial_trip');
            $table->foreign('company_id')->references('id')
                ->on('companies')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('source_city_id')->references('id')
                ->on('cities')->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('destination_city_id')->references('id')
                ->on('cities')->onUpdate('cascade')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('trip_lists');
    }
};
