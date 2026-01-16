<?php

namespace App\Filament\Resources\LessonExerciseResource\Pages;

use App\Filament\Resources\LessonExerciseResource;
use Filament\Resources\Pages\CreateRecord;

class CreateLessonExercise extends CreateRecord
{
    protected static string $resource = LessonExerciseResource::class;

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Latihan berhasil ditambahkan';
    }
}
