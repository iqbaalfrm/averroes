<?php

namespace App\Models;

class Article extends BaseModel
{
    protected $fillable = [
        'title',
        'source',
        'url',
        'image_url',
        'published_at',
    ];

    protected $casts = [
        'published_at' => 'datetime',
    ];
}
