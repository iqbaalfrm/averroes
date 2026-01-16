<?php

namespace App\Models;

class LessonExerciseQuestion extends BaseModel
{
    protected $fillable = [
        'exercise_id',
        'question_text',
        'explanation',
        'sort_order',
        'points',
    ];

    public function exercise()
    {
        return $this->belongsTo(LessonExercise::class, 'exercise_id');
    }

    public function options()
    {
        return $this->hasMany(LessonExerciseOption::class, 'question_id');
    }
}
