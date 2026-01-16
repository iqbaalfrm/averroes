<?php

namespace App\Filament\Resources\ClassLessonResource\Pages;

use App\Filament\Resources\ClassLessonResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateClassLesson extends CreateRecord
{
    protected static string $resource = ClassLessonResource::class;
    protected static ?string $title = 'Tambah Materi Kelas';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
