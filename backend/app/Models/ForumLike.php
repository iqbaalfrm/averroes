<?php

namespace App\Models;

class ForumLike extends BaseModel
{
    protected $fillable = [
        'user_id',
        'target_type',
        'target_id',
    ];
}
