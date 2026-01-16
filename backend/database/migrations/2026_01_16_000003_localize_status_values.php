<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasTable('articles')) {
            DB::table('articles')->where('status', 'published')->update(['status' => 'terbit']);
            DB::table('articles')->where('status', 'draft')->update(['status' => 'draf']);
        }

        if (Schema::hasTable('classes')) {
            DB::table('classes')->where('status', 'published')->update(['status' => 'terbit']);
            DB::table('classes')->where('status', 'draft')->update(['status' => 'draf']);
        }

        if (Schema::hasTable('books')) {
            DB::table('books')->where('status', 'published')->update(['status' => 'terbit']);
            DB::table('books')->where('status', 'draft')->update(['status' => 'draf']);
        }

        if (Schema::hasTable('forum_threads')) {
            DB::table('forum_threads')->where('status', 'open')->update(['status' => 'terbuka']);
            DB::table('forum_threads')->where('status', 'closed')->update(['status' => 'ditutup']);
        }

        if (Schema::hasTable('class_lessons')) {
            DB::table('class_lessons')->where('type', 'reading')->update(['type' => 'baca']);
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('articles')) {
            DB::table('articles')->where('status', 'terbit')->update(['status' => 'published']);
            DB::table('articles')->where('status', 'draf')->update(['status' => 'draft']);
        }

        if (Schema::hasTable('classes')) {
            DB::table('classes')->where('status', 'terbit')->update(['status' => 'published']);
            DB::table('classes')->where('status', 'draf')->update(['status' => 'draft']);
        }

        if (Schema::hasTable('books')) {
            DB::table('books')->where('status', 'terbit')->update(['status' => 'published']);
            DB::table('books')->where('status', 'draf')->update(['status' => 'draft']);
        }

        if (Schema::hasTable('forum_threads')) {
            DB::table('forum_threads')->where('status', 'terbuka')->update(['status' => 'open']);
            DB::table('forum_threads')->where('status', 'ditutup')->update(['status' => 'closed']);
        }

        if (Schema::hasTable('class_lessons')) {
            DB::table('class_lessons')->where('type', 'baca')->update(['type' => 'reading']);
        }
    }
};
