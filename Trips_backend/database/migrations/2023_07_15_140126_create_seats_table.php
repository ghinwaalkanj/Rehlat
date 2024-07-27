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
        Schema::create('seats', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('reservation_id')->nullable();
            $table->unsignedBigInteger('trip_id');
            $table->enum('status',['available','temporary','unavailable'])->default('available');
            $table->integer('number_seat');
            $table->dateTime('selected_date')->nullable();
            $table->boolean('is_selected')->default(false);
            $table->boolean('selected_by_user')->default(true);//for if selected my me or not
            $table->unsignedBigInteger('selected_user_id')->nullable();
            $table->string('name')->nullable();
            $table->integer('age')->nullable();
            $table->enum('gender',['male','female'])->nullable();
            $table->string('national_number')->nullable();
            $table->foreign('reservation_id')->references('id')
            ->on('reservations')->onUpdate('cascade')->onDelete('set null');
            $table->foreign('trip_id')->references('id')
            ->on('trips')->onUpdate('cascade')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('seats');
    }
};
