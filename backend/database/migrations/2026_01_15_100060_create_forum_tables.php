<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('forum_threads', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id')->nullable();
            $table->boolean('is_anonymous')->default(false);
            $table->string('category');
            $table->string('title');
            $table->longText('body')->nullable();
            $table->unsignedInteger('reply_count')->default(0);
            $table->unsignedInteger('like_count')->default(0);
            $table->boolean('is_hidden')->default(false);
            $table->boolean('is_locked')->default(false);
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
        });

        Schema::create('forum_replies', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('thread_id');
            $table->uuid('user_id')->nullable();
            $table->longText('body');
            $table->unsignedInteger('like_count')->default(0);
            $table->boolean('is_accepted')->default(false);
            $table->timestamps();

            $table->foreign('thread_id')->references('id')->on('forum_threads')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
        });

        Schema::create('forum_likes', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('target_type');
            $table->uuid('target_id');
            $table->timestamps();

            $table->unique(['user_id', 'target_type', 'target_id']);
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('forum_likes');
        Schema::dropIfExists('forum_replies');
        Schema::dropIfExists('forum_threads');
    }
};
