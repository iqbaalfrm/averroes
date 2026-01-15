<?php

namespace App\Models;

class ForumReply extends BaseModel
{
    protected $fillable = [
        'thread_id',
        'user_id',
        'body',
        'like_count',
        'is_accepted',
    ];

    protected $casts = [
        'is_accepted' => 'boolean',
    ];
}
