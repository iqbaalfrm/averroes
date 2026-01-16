<?php

namespace App\Models;

class ClassExamQuestion extends BaseModel
{
    protected $fillable = [
        'exam_id',
        'question_text',
        'explanation',
        'sort_order',
        'points',
    ];

    public function exam()
    {
        return $this->belongsTo(ClassExam::class, 'exam_id');
    }

    public function options()
    {
        return $this->hasMany(ClassExamOption::class, 'question_id');
    }
}
