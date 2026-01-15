<?php

namespace App\Models;

class Article extends BaseModel
{
    protected $fillable = [
        'title',
        'slug',
        'excerpt',
        'content',
        'cover_image_url',
        'source',
        'url',
        'image_url',
        'status',
        'published_at',
        'created_by',
    ];

    protected $casts = [
        'published_at' => 'datetime',
    ];
}
