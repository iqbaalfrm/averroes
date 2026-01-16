<?php

namespace App\Filament\Resources\ZakatRecordResource\Pages;

use App\Filament\Resources\ZakatRecordResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateZakatRecord extends CreateRecord
{
    protected static string $resource = ZakatRecordResource::class;
    protected static ?string $title = 'Tambah Perhitungan Zakat';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
