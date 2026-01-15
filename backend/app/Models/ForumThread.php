<?php

namespace App\Models;

class ForumThread extends BaseModel
{
    protected $fillable = [
        'user_id',
        'is_anonymous',
        'category',
        'title',
        'body',
        'reply_count',
        'like_count',
        'is_hidden',
        'is_locked',
    ];

    protected $casts = [
        'is_anonymous' => 'boolean',
        'is_hidden' => 'boolean',
        'is_locked' => 'boolean',
    ];

    public function replies()
    {
        return $this->hasMany(ForumReply::class, 'thread_id');
    }
}
