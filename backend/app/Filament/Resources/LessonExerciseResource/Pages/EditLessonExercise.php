<?php

namespace App\Filament\Resources\LessonExerciseResource\Pages;

use App\Filament\Resources\LessonExerciseResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditLessonExercise extends EditRecord
{
    protected static string $resource = LessonExerciseResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Latihan berhasil diperbarui';
    }
}
