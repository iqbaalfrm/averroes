<?php

namespace App\Models;

class MarketCoin extends BaseModel
{
    protected $fillable = [
        'code',
        'name',
        'price_usd',
        'change_24h',
        'change_7d',
        'volume_usd',
        'market_cap_usd',
    ];
}
