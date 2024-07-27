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
        Schema::create('mtn_operations', function (Blueprint $table) {
            $table->id();
            $table->string('operation_number');
            $table->string('invoice_number');
            $table->string('user_id');
            $table->string('reservation_id');
            $table->string('guid');
            $table->string('phone');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('mtn_operations');
    }
};
