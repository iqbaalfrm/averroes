<?php

namespace App\Models;

class ReelItem extends BaseModel
{
    protected $table = 'reels_items';

    protected $fillable = [
        'theme',
        'text_ar',
        'text_id',
        'audio_url',
        'source',
        'category',
        'verse_ref',
        'type',
        'is_active',
        'order_index',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];
}
