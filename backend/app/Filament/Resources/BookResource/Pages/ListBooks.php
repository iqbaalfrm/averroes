<?php

namespace App\Filament\Resources\BookResource\Pages;

use App\Filament\Resources\BookResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListBooks extends ListRecords
{
    protected static string $resource = BookResource::class;
}

class CreateBook extends CreateRecord
{
    protected static string $resource = BookResource::class;
}

class EditBook extends EditRecord
{
    protected static string $resource = BookResource::class;
}
