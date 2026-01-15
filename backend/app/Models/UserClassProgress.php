<?php

namespace App\Models;

class UserClassProgress extends BaseModel
{
    protected $table = 'user_class_progress';

    protected $fillable = [
        'user_id',
        'class_id',
        'last_lesson_id',
        'progress',
        'completed_lessons',
    ];

    protected $casts = [
        'completed_lessons' => 'array',
    ];
}
