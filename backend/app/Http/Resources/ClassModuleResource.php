<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ClassModuleResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'class_id' => $this->class_id,
            'title' => $this->title,
            'order' => $this->sort_order,
            'lessons' => $this->relationLoaded('lessons')
                ? ClassLessonResource::collection($this->lessons)->resolve()
                : [],
        ];
    }
}
