<?php

namespace App\Filament\Resources\EdukasiClassResource\Pages;

use App\Filament\Resources\EdukasiClassResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditEdukasiClass extends EditRecord
{
    protected static string $resource = EdukasiClassResource::class;
    protected static ?string $title = 'Ubah Kelas Edukasi';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Kelas Edukasi')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
