<?php

namespace App\Filament\Resources\ClassExamResource\Pages;

use App\Filament\Resources\ClassExamResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditClassExam extends EditRecord
{
    protected static string $resource = ClassExamResource::class;

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
        return 'Ujian berhasil diperbarui';
    }
}
