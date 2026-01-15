<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('classes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('title');
            $table->string('subtitle')->nullable();
            $table->string('level');
            $table->string('duration_text')->nullable();
            $table->unsignedInteger('lessons_count')->default(0);
            $table->text('description')->nullable();
            $table->json('outcomes')->nullable();
            $table->string('cover_theme')->nullable();
            $table->timestamps();
        });

        Schema::create('class_modules', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('class_id');
            $table->string('title');
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->foreign('class_id')->references('id')->on('classes')->onDelete('cascade');
        });

        Schema::create('class_lessons', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('module_id');
            $table->string('title');
            $table->string('type');
            $table->unsignedInteger('duration_min')->default(0);
            $table->longText('content')->nullable();
            $table->string('media_url')->nullable();
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->foreign('module_id')->references('id')->on('class_modules')->onDelete('cascade');
        });

        Schema::create('user_class_progress', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->uuid('class_id');
            $table->uuid('last_lesson_id')->nullable();
            $table->decimal('progress', 5, 2)->default(0);
            $table->json('completed_lessons')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'class_id']);
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('class_id')->references('id')->on('classes')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_class_progress');
        Schema::dropIfExists('class_lessons');
        Schema::dropIfExists('class_modules');
        Schema::dropIfExists('classes');
    }
};
