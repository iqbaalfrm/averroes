<?php

namespace App\Models;

class LessonExercise extends BaseModel
{
    protected $fillable = [
        'lesson_id',
        'title',
        'instructions',
        'passing_score',
        'max_attempts',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function lesson()
    {
        return $this->belongsTo(ClassLesson::class, 'lesson_id');
    }

    public function questions()
    {
        return $this->hasMany(LessonExerciseQuestion::class, 'exercise_id');
    }
}
