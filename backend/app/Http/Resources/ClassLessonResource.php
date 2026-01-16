<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\LessonExerciseResource;

class ClassLessonResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'class_id' => $this->class_id,
            'module_id' => $this->module_id,
            'title' => $this->title,
            'order' => $this->sort_order,
            'type' => $this->type,
            'duration_min' => $this->duration_min,
            'content' => $this->content,
            'video_url' => $this->media_url,
            'ayat_reference' => $this->ayat_reference,
            'ayat_arabic' => $this->ayat_arabic,
            'ayat_translation' => $this->ayat_translation,
            'exercise' => $this->relationLoaded('exercise')
                ? (new LessonExerciseResource($this->exercise))->resolve()
                : null,
        ];
    }
}
