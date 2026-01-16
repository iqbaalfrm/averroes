<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\ClassExamResource;
use App\Http\Resources\ClassModuleResource;

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
            'subtitle' => $this->subtitle,
            'level' => $this->level,
            'duration_minutes' => $this->duration_minutes,
            'duration_text' => $this->duration_text,
            'cover_theme' => $this->cover_theme,
            'cover_image_url' => $this->cover_image_url,
            'short_desc' => $this->short_desc ?: $this->subtitle,
            'description' => $this->description,
            'outcomes' => $this->outcomes ?? [],
            'lessons_count' => $this->lessons_count ?: count($lessons),
            'status' => $this->status ?? 'terbit',
            'modules' => $this->relationLoaded('modules')
                ? ClassModuleResource::collection($this->modules)->resolve()
                : [],
            'lessons' => $lessons,
            'exam' => $this->relationLoaded('exam')
                ? (new ClassExamResource($this->exam))->resolve()
                : null,
        ];
    }
}
