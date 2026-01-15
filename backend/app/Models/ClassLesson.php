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
        'sort_order',
    ];

    public function eduClass()
    {
        return $this->belongsTo(EdukasiClass::class, 'class_id');
    }
}
