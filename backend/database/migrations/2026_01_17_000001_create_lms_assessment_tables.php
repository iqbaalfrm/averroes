<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lesson_exercises', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('lesson_id');
            $table->string('title');
            $table->text('instructions')->nullable();
            $table->unsignedInteger('passing_score')->default(70);
            $table->unsignedInteger('max_attempts')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->foreign('lesson_id')->references('id')->on('class_lessons')->onDelete('cascade');
        });

        Schema::create('lesson_exercise_questions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('exercise_id');
            $table->longText('question_text');
            $table->longText('explanation')->nullable();
            $table->unsignedInteger('sort_order')->default(0);
            $table->unsignedInteger('points')->default(1);
            $table->timestamps();

            $table->foreign('exercise_id')->references('id')->on('lesson_exercises')->onDelete('cascade');
        });

        Schema::create('lesson_exercise_options', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('question_id');
            $table->text('option_text');
            $table->boolean('is_correct')->default(false);
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->foreign('question_id')->references('id')->on('lesson_exercise_questions')->onDelete('cascade');
        });

        Schema::create('class_exams', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('class_id');
            $table->string('title');
            $table->text('description')->nullable();
            $table->unsignedInteger('passing_score')->default(70);
            $table->unsignedInteger('duration_min')->nullable();
            $table->unsignedInteger('max_attempts')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->foreign('class_id')->references('id')->on('classes')->onDelete('cascade');
        });

        Schema::create('class_exam_questions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('exam_id');
            $table->longText('question_text');
            $table->longText('explanation')->nullable();
            $table->unsignedInteger('sort_order')->default(0);
            $table->unsignedInteger('points')->default(1);
            $table->timestamps();

            $table->foreign('exam_id')->references('id')->on('class_exams')->onDelete('cascade');
        });

        Schema::create('class_exam_options', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('question_id');
            $table->text('option_text');
            $table->boolean('is_correct')->default(false);
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->foreign('question_id')->references('id')->on('class_exam_questions')->onDelete('cascade');
        });

        Schema::create('lesson_exercise_attempts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('exercise_id');
            $table->uuid('user_id');
            $table->unsignedInteger('score')->default(0);
            $table->unsignedInteger('total_questions')->default(0);
            $table->unsignedInteger('correct_count')->default(0);
            $table->string('status')->default('gagal');
            $table->timestamp('started_at')->nullable();
            $table->timestamp('finished_at')->nullable();
            $table->timestamps();

            $table->foreign('exercise_id')->references('id')->on('lesson_exercises')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('lesson_exercise_answers', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('attempt_id');
            $table->uuid('question_id');
            $table->uuid('selected_option_id')->nullable();
            $table->boolean('is_correct')->default(false);
            $table->timestamps();

            $table->foreign('attempt_id')->references('id')->on('lesson_exercise_attempts')->onDelete('cascade');
            $table->foreign('question_id')->references('id')->on('lesson_exercise_questions')->onDelete('cascade');
            $table->foreign('selected_option_id')->references('id')->on('lesson_exercise_options')->nullOnDelete();
        });

        Schema::create('class_exam_attempts', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('exam_id');
            $table->uuid('user_id');
            $table->unsignedInteger('score')->default(0);
            $table->unsignedInteger('total_questions')->default(0);
            $table->unsignedInteger('correct_count')->default(0);
            $table->string('status')->default('gagal');
            $table->timestamp('started_at')->nullable();
            $table->timestamp('finished_at')->nullable();
            $table->timestamps();

            $table->foreign('exam_id')->references('id')->on('class_exams')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('class_exam_answers', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('attempt_id');
            $table->uuid('question_id');
            $table->uuid('selected_option_id')->nullable();
            $table->boolean('is_correct')->default(false);
            $table->timestamps();

            $table->foreign('attempt_id')->references('id')->on('class_exam_attempts')->onDelete('cascade');
            $table->foreign('question_id')->references('id')->on('class_exam_questions')->onDelete('cascade');
            $table->foreign('selected_option_id')->references('id')->on('class_exam_options')->nullOnDelete();
        });

        Schema::create('class_certificates', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('class_id');
            $table->uuid('user_id');
            $table->string('certificate_number')->unique();
            $table->unsignedInteger('final_score')->default(0);
            $table->timestamp('issued_at')->nullable();
            $table->string('qr_payload');
            $table->timestamps();

            $table->foreign('class_id')->references('id')->on('classes')->onDelete('cascade');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('class_certificates');
        Schema::dropIfExists('class_exam_answers');
        Schema::dropIfExists('class_exam_attempts');
        Schema::dropIfExists('lesson_exercise_answers');
        Schema::dropIfExists('lesson_exercise_attempts');
        Schema::dropIfExists('class_exam_options');
        Schema::dropIfExists('class_exam_questions');
        Schema::dropIfExists('class_exams');
        Schema::dropIfExists('lesson_exercise_options');
        Schema::dropIfExists('lesson_exercise_questions');
        Schema::dropIfExists('lesson_exercises');
    }
};
