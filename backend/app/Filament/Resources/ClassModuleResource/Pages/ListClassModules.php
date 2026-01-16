<?php

namespace App\Filament\Resources\ClassModuleResource\Pages;

use App\Filament\Resources\ClassModuleResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListClassModules extends ListRecords
{
    protected static string $resource = ClassModuleResource::class;
    protected static ?string $title = 'Modul Kelas';
    protected static ?string $breadcrumb = 'Modul Kelas';

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
