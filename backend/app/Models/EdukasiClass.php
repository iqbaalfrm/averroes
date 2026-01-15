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
        'lessons_count',
        'description',
        'outcomes',
        'cover_theme',
    ];

    protected $casts = [
        'outcomes' => 'array',
    ];

    public function modules()
    {
        return $this->hasMany(ClassModule::class, 'class_id');
    }
}
