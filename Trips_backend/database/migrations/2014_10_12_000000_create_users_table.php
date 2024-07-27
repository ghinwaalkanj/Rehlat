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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name')->nullable();
            $table->string('phone');
            $table->boolean('mobile_verified')->default(false);
            $table->string('username')->unique()->nullable();
            $table->integer('age')->nullable();
            $table->enum('gender',['male','female'])->nullable();
            $table->string('naunal_number')->nullable();
            $table->json('rate_ids')->nullable();
            $table->unsignedBigInteger('rate_trip')->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
