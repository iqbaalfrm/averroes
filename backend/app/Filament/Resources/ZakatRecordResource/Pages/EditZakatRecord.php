<?php

namespace App\Filament\Resources\ZakatRecordResource\Pages;

use App\Filament\Resources\ZakatRecordResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditZakatRecord extends EditRecord
{
    protected static string $resource = ZakatRecordResource::class;
    protected static ?string $title = 'Ubah Perhitungan Zakat';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Perhitungan Zakat')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
