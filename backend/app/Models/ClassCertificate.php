<?php

namespace App\Models;

class ClassCertificate extends BaseModel
{
    protected $fillable = [
        'class_id',
        'user_id',
        'certificate_number',
        'final_score',
        'issued_at',
        'qr_payload',
    ];

    protected $casts = [
        'issued_at' => 'datetime',
    ];

    public function eduClass()
    {
        return $this->belongsTo(EdukasiClass::class, 'class_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
