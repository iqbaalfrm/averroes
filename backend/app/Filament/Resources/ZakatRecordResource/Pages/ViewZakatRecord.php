<?php

namespace App\Filament\Resources\ZakatRecordResource\Pages;

use App\Filament\Resources\ZakatRecordResource;
use Filament\Resources\Pages\ViewRecord;

class ViewZakatRecord extends ViewRecord
{
    protected static string $resource = ZakatRecordResource::class;
    protected static ?string $title = 'Detail Perhitungan Zakat';
    protected static ?string $breadcrumb = 'Detail';
}
