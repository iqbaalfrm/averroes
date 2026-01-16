<?php

namespace App\Filament\Resources\BookResource\Pages;

use App\Filament\Resources\BookResource;
use Filament\Resources\Pages\ViewRecord;

class ViewBook extends ViewRecord
{
    protected static string $resource = BookResource::class;
    protected static ?string $title = 'Detail Buku';
    protected static ?string $breadcrumb = 'Detail';
}
