<?php

namespace App\Filament\Resources\EdukasiClassResource\Pages;

use App\Filament\Resources\EdukasiClassResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListEdukasiClasses extends ListRecords
{
    protected static string $resource = EdukasiClassResource::class;
    protected static ?string $title = 'Kelas Edukasi';
    protected static ?string $breadcrumb = 'Kelas Edukasi';

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
