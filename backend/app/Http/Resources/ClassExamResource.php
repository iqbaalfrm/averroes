<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ClassExamResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'class_id' => $this->class_id,
            'title' => $this->title,
            'description' => $this->description,
            'passing_score' => $this->passing_score,
            'duration_min' => $this->duration_min,
            'max_attempts' => $this->max_attempts,
            'is_active' => $this->is_active,
            'questions' => $this->relationLoaded('questions')
                ? ClassExamQuestionResource::collection($this->questions)->resolve()
                : [],
        ];
    }
}
