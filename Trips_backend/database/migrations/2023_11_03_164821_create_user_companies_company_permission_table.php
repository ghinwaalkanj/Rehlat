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
        Schema::create('user_companies_company_permission', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_company_id')->constrained('user_companies');
            $table->foreignId('company_permission_id')->constrained('company_permissions');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_companies_company_permission');
    }
};
