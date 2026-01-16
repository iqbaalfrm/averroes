<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ClassCertificateResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->id,
            'class_id' => $this->class_id,
            'user_id' => $this->user_id,
            'certificate_number' => $this->certificate_number,
            'final_score' => $this->final_score,
            'issued_at' => optional($this->issued_at)->toISOString(),
            'qr_payload' => $this->qr_payload,
            'class_title' => $this->whenLoaded('eduClass', function () {
                return $this->eduClass?->title;
            }),
        ];
    }
}
