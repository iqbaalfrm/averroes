<?php

namespace App\Filament\Resources\ClassLessonResource\Pages;

use App\Filament\Resources\ClassLessonResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditClassLesson extends EditRecord
{
    protected static string $resource = ClassLessonResource::class;
    protected static ?string $title = 'Ubah Materi Kelas';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Materi Kelas')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
