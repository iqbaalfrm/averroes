<?php

namespace App\Models;

class ClassExamAnswer extends BaseModel
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
        return $this->belongsTo(ClassExamAttempt::class, 'attempt_id');
    }

    public function question()
    {
        return $this->belongsTo(ClassExamQuestion::class, 'question_id');
    }

    public function selectedOption()
    {
        return $this->belongsTo(ClassExamOption::class, 'selected_option_id');
    }
}
