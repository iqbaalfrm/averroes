<?php

namespace App\Models;

class ClassLesson extends BaseModel
{
    protected $fillable = [
        'module_id',
        'title',
        'type',
        'duration_min',
        'content',
        'media_url',
        'sort_order',
    ];
}
