<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('books', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('original_title');
            $table->string('display_title')->nullable();
            $table->string('author')->nullable();
            $table->string('language')->nullable();
            $table->string('category')->nullable();
            $table->unsignedInteger('pages')->nullable();
            $table->text('description')->nullable();
            $table->string('pdf_url');
            $table->string('cover_url')->nullable();
            $table->timestamps();
        });

        Schema::create('user_bookmarks', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->string('type');
            $table->uuid('ref_id');
            $table->timestamps();

            $table->unique(['user_id', 'type', 'ref_id']);
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('user_book_progress', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('user_id');
            $table->uuid('book_id');
            $table->unsignedInteger('last_page')->default(0);
            $table->unsignedInteger('page_count')->default(0);
            $table->timestamps();

            $table->unique(['user_id', 'book_id']);
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('book_id')->references('id')->on('books')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_book_progress');
        Schema::dropIfExists('user_bookmarks');
        Schema::dropIfExists('books');
    }
};
