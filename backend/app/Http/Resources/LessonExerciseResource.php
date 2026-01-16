<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LessonExerciseResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'lesson_id' => $this->lesson_id,
            'title' => $this->title,
            'instructions' => $this->instructions,
            'passing_score' => $this->passing_score,
            'max_attempts' => $this->max_attempts,
            'is_active' => $this->is_active,
            'questions' => $this->relationLoaded('questions')
                ? LessonExerciseQuestionResource::collection($this->questions)->resolve()
                : [],
        ];
    }
}
