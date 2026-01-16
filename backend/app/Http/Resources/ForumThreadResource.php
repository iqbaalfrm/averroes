<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ForumThreadResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'user_id' => $this->user_id,
            'title' => $this->title,
            'body' => $this->body,
            'tags' => $this->tags ?? [],
            'status' => $this->status ?? 'terbuka',
            'category' => $this->category,
            'reply_count' => $this->reply_count,
            'like_count' => $this->like_count,
            'is_hidden' => (bool) $this->is_hidden,
            'is_locked' => (bool) $this->is_locked,
            'created_at' => optional($this->created_at)->toISOString(),
            'replies' => $this->relationLoaded('replies')
                ? ForumReplyResource::collection($this->replies)->resolve()
                : [],
        ];
    }
}
