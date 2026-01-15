<?php

namespace App\Models;

class ZakatRecord extends BaseModel
{
    protected $fillable = [
        'user_id',
        'total_assets_idr',
        'gold_price_idr_per_gram',
        'nishab_idr',
        'zakat_due_idr',
        'method',
    ];
}
