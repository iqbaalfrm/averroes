<?php

namespace App\Filament\Resources\LessonExerciseResource\Pages;

use App\Filament\Resources\LessonExerciseResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListLessonExercises extends ListRecords
{
    protected static string $resource = LessonExerciseResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
