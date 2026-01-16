<?php

namespace App\Models;

class LessonExerciseAttempt extends BaseModel
{
    protected $fillable = [
        'exercise_id',
        'user_id',
        'score',
        'total_questions',
        'correct_count',
        'status',
        'started_at',
        'finished_at',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'finished_at' => 'datetime',
    ];

    public function exercise()
    {
        return $this->belongsTo(LessonExercise::class, 'exercise_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function answers()
    {
        return $this->hasMany(LessonExerciseAnswer::class, 'attempt_id');
    }
}
