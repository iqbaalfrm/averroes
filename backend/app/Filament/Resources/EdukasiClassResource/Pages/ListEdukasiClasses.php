<?php

namespace App\Filament\Resources\EdukasiClassResource\Pages;

use App\Filament\Resources\EdukasiClassResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListEdukasiClasses extends ListRecords
{
    protected static string $resource = EdukasiClassResource::class;
}

class CreateEdukasiClass extends CreateRecord
{
    protected static string $resource = EdukasiClassResource::class;
}

class EditEdukasiClass extends EditRecord
{
    protected static string $resource = EdukasiClassResource::class;
}
