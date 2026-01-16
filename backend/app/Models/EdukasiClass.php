<?php

namespace App\Models;

class EdukasiClass extends BaseModel
{
    protected $table = 'classes';

    protected $fillable = [
        'title',
        'subtitle',
        'level',
        'duration_text',
        'duration_minutes',
        'lessons_count',
        'short_desc',
        'description',
        'outcomes',
        'cover_theme',
        'cover_image_url',
        'status',
    ];

    protected $casts = [
        'outcomes' => 'array',
    ];

    public function modules()
    {
        return $this->hasMany(ClassModule::class, 'class_id');
    }

    public function lessons()
    {
        return $this->hasMany(ClassLesson::class, 'class_id');
    }

    public function exam()
    {
        return $this->hasOne(ClassExam::class, 'class_id');
    }

    public function certificates()
    {
        return $this->hasMany(ClassCertificate::class, 'class_id');
    }
}
