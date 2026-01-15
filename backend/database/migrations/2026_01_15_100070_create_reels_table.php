<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reels_items', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('theme');
            $table->text('text_ar')->nullable();
            $table->text('text_id');
            $table->string('audio_url')->nullable();
            $table->string('source')->nullable();
            $table->string('category')->nullable();
            $table->string('verse_ref')->nullable();
            $table->string('type')->nullable();
            $table->boolean('is_active')->default(true);
            $table->unsignedInteger('order_index')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reels_items');
    }
};
