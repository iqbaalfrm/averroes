<?php

namespace App\Models;

class PortfolioAsset extends BaseModel
{
    protected $fillable = [
        'user_id',
        'coin_code',
        'coin_name',
        'network',
        'amount',
        'avg_buy_price_usd',
        'notes',
    ];
}
