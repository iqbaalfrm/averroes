<?php

namespace App\Models;

class UserBookProgress extends BaseModel
{
    protected $table = 'user_book_progress';

    protected $fillable = [
        'user_id',
        'book_id',
        'last_page',
        'page_count',
    ];
}
