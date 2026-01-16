<?php

namespace App\Models;

class LessonExerciseAnswer extends BaseModel
{
    protected $fillable = [
        'attempt_id',
        'question_id',
        'selected_option_id',
        'is_correct',
    ];

    protected $casts = [
        'is_correct' => 'boolean',
    ];

    public function attempt()
    {
        return $this->belongsTo(LessonExerciseAttempt::class, 'attempt_id');
    }

    public function question()
    {
        return $this->belongsTo(LessonExerciseQuestion::class, 'question_id');
    }

    public function selectedOption()
    {
        return $this->belongsTo(LessonExerciseOption::class, 'selected_option_id');
    }
}
