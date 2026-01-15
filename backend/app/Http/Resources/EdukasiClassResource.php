<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EdukasiClassResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $lessons = [];

        if ($this->relationLoaded('lessons')) {
            $lessons = ClassLessonResource::collection($this->lessons)->resolve();
        } elseif ($this->relationLoaded('modules')) {
            $lessons = $this->modules
                ->flatMap(fn ($module) => $module->lessons ?? [])
                ->sortBy('sort_order')
                ->values()
                ->map(fn ($lesson) => (new ClassLessonResource($lesson))->resolve())
                ->all();
        }

        return [
            'id' => (string) $this->id,
            'title' => $this->title,
            'level' => $this->level,
            'duration_minutes' => $this->duration_minutes,
            'duration_text' => $this->duration_text,
            'cover_image_url' => $this->cover_image_url,
            'short_desc' => $this->short_desc ?: $this->subtitle,
            'description' => $this->description,
            'lessons_count' => $this->lessons_count ?: count($lessons),
            'status' => $this->status ?? 'published',
            'lessons' => $lessons,
        ];
    }
}
