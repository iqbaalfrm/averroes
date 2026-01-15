<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ForumReplyResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'thread_id' => $this->thread_id,
            'user_id' => $this->user_id,
            'body' => $this->body,
            'like_count' => $this->like_count,
            'is_accepted' => (bool) $this->is_accepted,
            'created_at' => optional($this->created_at)->toISOString(),
        ];
    }
}
