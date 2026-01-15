<?php

namespace App\Models;

class UserBookmark extends BaseModel
{
    protected $table = 'user_bookmarks';

    protected $fillable = [
        'user_id',
        'type',
        'ref_id',
    ];
}
