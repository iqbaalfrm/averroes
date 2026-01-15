<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('screener_coins', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('code')->unique();
            $table->string('name');
            $table->string('status');
            $table->decimal('price_usd', 24, 8)->nullable();
            $table->decimal('market_cap_usd', 24, 2)->nullable();
            $table->text('explanation')->nullable();
            $table->json('details')->nullable();
            $table->timestamps();
        });

        Schema::create('market_coins', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('code')->unique();
            $table->string('name');
            $table->decimal('price_usd', 24, 8)->nullable();
            $table->decimal('change_24h', 10, 4)->nullable();
            $table->decimal('change_7d', 10, 4)->nullable();
            $table->decimal('volume_usd', 24, 2)->nullable();
            $table->decimal('market_cap_usd', 24, 2)->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('market_coins');
        Schema::dropIfExists('screener_coins');
    }
};
