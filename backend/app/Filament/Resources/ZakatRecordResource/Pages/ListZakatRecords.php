<?php

namespace App\Filament\Resources\ZakatRecordResource\Pages;

use App\Filament\Resources\ZakatRecordResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListZakatRecords extends ListRecords
{
    protected static string $resource = ZakatRecordResource::class;
}

class CreateZakatRecord extends CreateRecord
{
    protected static string $resource = ZakatRecordResource::class;
}

class EditZakatRecord extends EditRecord
{
    protected static string $resource = ZakatRecordResource::class;
}
