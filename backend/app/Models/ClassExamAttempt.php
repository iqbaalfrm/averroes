<?php

namespace App\Models;

class ClassExamAttempt extends BaseModel
{
    protected $fillable = [
        'exam_id',
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

    public function exam()
    {
        return $this->belongsTo(ClassExam::class, 'exam_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function answers()
    {
        return $this->hasMany(ClassExamAnswer::class, 'attempt_id');
    }
}
