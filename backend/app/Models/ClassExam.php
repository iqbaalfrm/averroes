<?php

namespace App\Models;

class ClassExam extends BaseModel
{
    protected $fillable = [
        'class_id',
        'title',
        'description',
        'passing_score',
        'duration_min',
        'max_attempts',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function eduClass()
    {
        return $this->belongsTo(EdukasiClass::class, 'class_id');
    }

    public function questions()
    {
        return $this->hasMany(ClassExamQuestion::class, 'exam_id');
    }
}
