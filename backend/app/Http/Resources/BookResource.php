<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'display_title' => $this->display_title ?: $this->original_title,
            'original_title' => $this->original_title,
            'author' => $this->author,
            'category' => $this->category,
            'pages' => $this->pages,
            'language' => $this->language,
            'description' => $this->description,
            'pdf_url' => $this->pdf_url,
            'cover_image_url' => $this->cover_image_url ?: $this->cover_url,
            'status' => $this->status ?? 'terbit',
        ];
    }
}
