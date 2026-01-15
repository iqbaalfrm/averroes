<?php

namespace App\Models;

class ScreenerCoin extends BaseModel
{
    protected $fillable = [
        'code',
        'name',
        'status',
        'price_usd',
        'market_cap_usd',
        'explanation',
        'details',
    ];

    protected $casts = [
        'details' => 'array',
    ];
}
