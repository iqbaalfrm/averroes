<?php

namespace App\Filament\Resources\ClassExamResource\Pages;

use App\Filament\Resources\ClassExamResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListClassExams extends ListRecords
{
    protected static string $resource = ClassExamResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
