<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('articles', function (Blueprint $table) {
            if (!Schema::hasColumn('articles', 'slug')) {
                $table->string('slug')->nullable()->unique();
            }
            if (!Schema::hasColumn('articles', 'excerpt')) {
                $table->text('excerpt')->nullable();
            }
            if (!Schema::hasColumn('articles', 'content')) {
                $table->longText('content')->nullable();
            }
            if (!Schema::hasColumn('articles', 'cover_image_url')) {
                $table->string('cover_image_url')->nullable();
            }
            if (!Schema::hasColumn('articles', 'status')) {
                $table->string('status')->default('published');
            }
            if (!Schema::hasColumn('articles', 'created_by')) {
                $table->uuid('created_by')->nullable();
                $table->foreign('created_by')->references('id')->on('users')->nullOnDelete();
            }
        });

        Schema::table('classes', function (Blueprint $table) {
            if (!Schema::hasColumn('classes', 'duration_minutes')) {
                $table->unsignedInteger('duration_minutes')->nullable();
            }
            if (!Schema::hasColumn('classes', 'cover_image_url')) {
                $table->string('cover_image_url')->nullable();
            }
            if (!Schema::hasColumn('classes', 'short_desc')) {
                $table->string('short_desc')->nullable();
            }
            if (!Schema::hasColumn('classes', 'status')) {
                $table->string('status')->default('published');
            }
        });

        Schema::table('class_lessons', function (Blueprint $table) {
            if (!Schema::hasColumn('class_lessons', 'class_id')) {
                $table->uuid('class_id')->nullable()->index();
                $table->foreign('class_id')->references('id')->on('classes')->nullOnDelete();
            }
        });

        Schema::table('books', function (Blueprint $table) {
            if (!Schema::hasColumn('books', 'cover_image_url')) {
                $table->string('cover_image_url')->nullable();
            }
            if (!Schema::hasColumn('books', 'status')) {
                $table->string('status')->default('published');
            }
        });

        Schema::table('forum_threads', function (Blueprint $table) {
            if (!Schema::hasColumn('forum_threads', 'tags')) {
                $table->json('tags')->nullable();
            }
            if (!Schema::hasColumn('forum_threads', 'status')) {
                $table->string('status')->default('open');
            }
        });

        if (Schema::hasColumn('class_lessons', 'class_id')) {
            DB::statement('update class_lessons cl set class_id = cm.class_id from class_modules cm where cl.module_id = cm.id and cl.class_id is null');
        }
    }

    public function down(): void
    {
        Schema::table('articles', function (Blueprint $table) {
            if (Schema::hasColumn('articles', 'created_by')) {
                $table->dropForeign(['created_by']);
                $table->dropColumn('created_by');
            }
            if (Schema::hasColumn('articles', 'status')) {
                $table->dropColumn('status');
            }
            if (Schema::hasColumn('articles', 'cover_image_url')) {
                $table->dropColumn('cover_image_url');
            }
            if (Schema::hasColumn('articles', 'content')) {
                $table->dropColumn('content');
            }
            if (Schema::hasColumn('articles', 'excerpt')) {
                $table->dropColumn('excerpt');
            }
            if (Schema::hasColumn('articles', 'slug')) {
                $table->dropColumn('slug');
            }
        });

        Schema::table('classes', function (Blueprint $table) {
            if (Schema::hasColumn('classes', 'status')) {
                $table->dropColumn('status');
            }
            if (Schema::hasColumn('classes', 'short_desc')) {
                $table->dropColumn('short_desc');
            }
            if (Schema::hasColumn('classes', 'cover_image_url')) {
                $table->dropColumn('cover_image_url');
            }
            if (Schema::hasColumn('classes', 'duration_minutes')) {
                $table->dropColumn('duration_minutes');
            }
        });

        Schema::table('class_lessons', function (Blueprint $table) {
            if (Schema::hasColumn('class_lessons', 'class_id')) {
                $table->dropForeign(['class_id']);
                $table->dropColumn('class_id');
            }
        });

        Schema::table('books', function (Blueprint $table) {
            if (Schema::hasColumn('books', 'status')) {
                $table->dropColumn('status');
            }
            if (Schema::hasColumn('books', 'cover_image_url')) {
                $table->dropColumn('cover_image_url');
            }
        });

        Schema::table('forum_threads', function (Blueprint $table) {
            if (Schema::hasColumn('forum_threads', 'status')) {
                $table->dropColumn('status');
            }
            if (Schema::hasColumn('forum_threads', 'tags')) {
                $table->dropColumn('tags');
            }
        });
    }
};
