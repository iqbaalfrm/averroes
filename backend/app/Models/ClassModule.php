<?php

namespace App\Models;

class ClassModule extends BaseModel
{
    protected $fillable = [
        'class_id',
        'title',
        'sort_order',
    ];

    public function lessons()
    {
        return $this->hasMany(ClassLesson::class, 'module_id');
    }

    public function eduClass()
    {
        return $this->belongsTo(EdukasiClass::class, 'class_id');
    }
}
