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
        Schema::table('trip_lists', function (Blueprint $table) {
            $table->unsignedBigInteger('driver_id')->nullable();
            $table->unsignedBigInteger('driver_assistant_id')->nullable();
            $table->foreign('driver_id')->references('id')->on('drivers')
                ->onUpdate('cascade')->onDelete('cascade');
            $table->foreign('driver_assistant_id')->references('id')->on('driver_assistants')
                ->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('trip_lists', function (Blueprint $table) {
            //
        });
    }
};
