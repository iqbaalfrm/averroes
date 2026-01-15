<?php

namespace App\Models;

class Book extends BaseModel
{
    protected $fillable = [
        'original_title',
        'display_title',
        'author',
        'language',
        'category',
        'pages',
        'description',
        'pdf_url',
        'cover_url',
        'cover_image_url',
        'status',
    ];
}
