<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('class_lessons', function (Blueprint $table) {
            if (!Schema::hasColumn('class_lessons', 'ayat_reference')) {
                $table->string('ayat_reference')->nullable();
            }
            if (!Schema::hasColumn('class_lessons', 'ayat_arabic')) {
                $table->longText('ayat_arabic')->nullable();
            }
            if (!Schema::hasColumn('class_lessons', 'ayat_translation')) {
                $table->longText('ayat_translation')->nullable();
            }
        });
    }

    public function down(): void
    {
        Schema::table('class_lessons', function (Blueprint $table) {
            if (Schema::hasColumn('class_lessons', 'ayat_translation')) {
                $table->dropColumn('ayat_translation');
            }
            if (Schema::hasColumn('class_lessons', 'ayat_arabic')) {
                $table->dropColumn('ayat_arabic');
            }
            if (Schema::hasColumn('class_lessons', 'ayat_reference')) {
                $table->dropColumn('ayat_reference');
            }
        });
    }
};
