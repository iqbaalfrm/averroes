<?php

namespace App\Filament\Resources\ClassModuleResource\Pages;

use App\Filament\Resources\ClassModuleResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListClassModules extends ListRecords
{
    protected static string $resource = ClassModuleResource::class;
}

class CreateClassModule extends CreateRecord
{
    protected static string $resource = ClassModuleResource::class;
}

class EditClassModule extends EditRecord
{
    protected static string $resource = ClassModuleResource::class;
}
