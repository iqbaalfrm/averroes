<?php

namespace App\Filament\Resources\ClassLessonResource\Pages;

use App\Filament\Resources\ClassLessonResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListClassLessons extends ListRecords
{
    protected static string $resource = ClassLessonResource::class;
    protected static ?string $title = 'Materi Kelas';
    protected static ?string $breadcrumb = 'Materi Kelas';

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
