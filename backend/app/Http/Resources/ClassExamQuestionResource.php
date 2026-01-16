<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ClassExamQuestionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'question_text' => $this->question_text,
            'order' => $this->sort_order,
            'points' => $this->points,
            'options' => $this->relationLoaded('options')
                ? ClassExamOptionResource::collection($this->options)->resolve()
                : [],
        ];
    }
}
