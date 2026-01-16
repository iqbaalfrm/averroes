<?php

namespace App\Filament\Resources\ClassModuleResource\Pages;

use App\Filament\Resources\ClassModuleResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditClassModule extends EditRecord
{
    protected static string $resource = ClassModuleResource::class;
    protected static ?string $title = 'Ubah Modul Kelas';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Modul Kelas')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
