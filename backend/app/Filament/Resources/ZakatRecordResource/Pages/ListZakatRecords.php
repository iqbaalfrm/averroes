<?php

namespace App\Filament\Resources\ZakatRecordResource\Pages;

use App\Filament\Resources\ZakatRecordResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListZakatRecords extends ListRecords
{
    protected static string $resource = ZakatRecordResource::class;
    protected static ?string $title = 'Perhitungan Zakat';
    protected static ?string $breadcrumb = 'Perhitungan Zakat';

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
