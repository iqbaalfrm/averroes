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
            if (!Schema::hasColumn('articles', 'status')) {
                $table->string('status')->default('terbit');
            }
        });

        Schema::table('classes', function (Blueprint $table) {
            if (!Schema::hasColumn('classes', 'status')) {
                $table->string('status')->default('terbit');
            }
        });

        Schema::table('books', function (Blueprint $table) {
            if (!Schema::hasColumn('books', 'status')) {
                $table->string('status')->default('terbit');
            }
        });

        Schema::table('forum_threads', function (Blueprint $table) {
            if (!Schema::hasColumn('forum_threads', 'status')) {
                $table->string('status')->default('terbuka');
            }
        });

        Schema::table('class_lessons', function (Blueprint $table) {
            if (!Schema::hasColumn('class_lessons', 'class_id')) {
                $table->uuid('class_id')->nullable()->index();
            }
        });

        if (Schema::hasTable('class_lessons') && Schema::hasTable('class_modules') && Schema::hasColumn('class_lessons', 'class_id')) {
            $driver = DB::getDriverName();
            if ($driver === 'mysql') {
                DB::statement(
                    'update class_lessons cl
                    join class_modules cm on cl.module_id = cm.id
                    set cl.class_id = cm.class_id
                    where cl.class_id is null'
                );
            } elseif ($driver === 'pgsql') {
                DB::statement(
                    'update class_lessons cl
                    set class_id = cm.class_id
                    from class_modules cm
                    where cl.module_id = cm.id and cl.class_id is null'
                );
            }
        }

        if (Schema::hasTable('articles') && Schema::hasColumn('articles', 'status')) {
            DB::table('articles')->whereNull('status')->update(['status' => 'terbit']);
        }
        if (Schema::hasTable('classes') && Schema::hasColumn('classes', 'status')) {
            DB::table('classes')->whereNull('status')->update(['status' => 'terbit']);
        }
        if (Schema::hasTable('books') && Schema::hasColumn('books', 'status')) {
            DB::table('books')->whereNull('status')->update(['status' => 'terbit']);
        }
        if (Schema::hasTable('forum_threads') && Schema::hasColumn('forum_threads', 'status')) {
            DB::table('forum_threads')->whereNull('status')->update(['status' => 'terbuka']);
        }
    }

    public function down(): void
    {
        Schema::table('articles', function (Blueprint $table) {
            if (Schema::hasColumn('articles', 'status')) {
                $table->dropColumn('status');
            }
        });

        Schema::table('classes', function (Blueprint $table) {
            if (Schema::hasColumn('classes', 'status')) {
                $table->dropColumn('status');
            }
        });

        Schema::table('books', function (Blueprint $table) {
            if (Schema::hasColumn('books', 'status')) {
                $table->dropColumn('status');
            }
        });

        Schema::table('forum_threads', function (Blueprint $table) {
            if (Schema::hasColumn('forum_threads', 'status')) {
                $table->dropColumn('status');
            }
        });

        Schema::table('class_lessons', function (Blueprint $table) {
            if (Schema::hasColumn('class_lessons', 'class_id')) {
                $table->dropColumn('class_id');
            }
        });
    }
};
