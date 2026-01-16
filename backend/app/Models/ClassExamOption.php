<?php

namespace App\Models;

class ClassExamOption extends BaseModel
{
    protected $fillable = [
        'question_id',
        'option_text',
        'is_correct',
        'sort_order',
    ];

    protected $casts = [
        'is_correct' => 'boolean',
    ];

    public function question()
    {
        return $this->belongsTo(ClassExamQuestion::class, 'question_id');
    }
}
