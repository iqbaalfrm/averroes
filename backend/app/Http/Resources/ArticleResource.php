<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Str;

class ArticleResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $slug = $this->slug ?: Str::slug($this->title ?? '');

        return [
            'id' => (string) $this->id,
            'title' => $this->title,
            'slug' => $slug,
            'excerpt' => $this->excerpt,
            'content' => $this->content,
            'cover_image_url' => $this->cover_image_url ?: $this->image_url,
            'source' => $this->source,
            'url' => $this->url,
            'status' => $this->status ?? 'published',
            'published_at' => optional($this->published_at)->toISOString(),
            'created_by' => $this->created_by,
        ];
    }
}
