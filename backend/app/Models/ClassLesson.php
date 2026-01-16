<?php

namespace App\Models;

class ClassLesson extends BaseModel
{
    protected $fillable = [
        'class_id',
        'module_id',
        'title',
        'type',
        'duration_min',
        'content',
        'media_url',
        'ayat_reference',
        'ayat_arabic',
        'ayat_translation',
        'sort_order',
    ];

    public function eduClass()
    {
        return $this->belongsTo(EdukasiClass::class, 'class_id');
    }

    public function module()
    {
        return $this->belongsTo(ClassModule::class, 'module_id');
    }

    public function exercise()
    {
        return $this->hasOne(LessonExercise::class, 'lesson_id');
    }
}
