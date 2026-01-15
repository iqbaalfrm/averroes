<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('portfolio_assets', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('coin_code');
            $table->string('coin_name');
            $table->string('network')->default('spot');
            $table->decimal('amount', 24, 8);
            $table->decimal('avg_buy_price_usd', 24, 8)->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('zakat_records', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->decimal('total_assets_idr', 24, 2)->default(0);
            $table->decimal('gold_price_idr_per_gram', 24, 2)->default(0);
            $table->decimal('nishab_idr', 24, 2)->default(0);
            $table->decimal('zakat_due_idr', 24, 2)->default(0);
            $table->string('method')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('zakat_records');
        Schema::dropIfExists('portfolio_assets');
    }
};
