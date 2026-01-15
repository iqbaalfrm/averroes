<?php

namespace App\Models;

class Profile extends BaseModel
{
    protected $fillable = [
        'id',
        'email',
        'display_name',
        'avatar_url',
        'role',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id');
    }
}
