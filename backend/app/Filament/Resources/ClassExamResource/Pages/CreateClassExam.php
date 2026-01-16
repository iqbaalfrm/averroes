<?php

namespace App\Filament\Resources\ClassExamResource\Pages;

use App\Filament\Resources\ClassExamResource;
use Filament\Resources\Pages\CreateRecord;

class CreateClassExam extends CreateRecord
{
    protected static string $resource = ClassExamResource::class;

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Ujian berhasil ditambahkan';
    }
}
