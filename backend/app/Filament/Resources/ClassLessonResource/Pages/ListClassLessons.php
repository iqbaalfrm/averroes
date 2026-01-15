<?php

namespace App\Filament\Resources\ClassLessonResource\Pages;

use App\Filament\Resources\ClassLessonResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListClassLessons extends ListRecords
{
    protected static string $resource = ClassLessonResource::class;
}

class CreateClassLesson extends CreateRecord
{
    protected static string $resource = ClassLessonResource::class;
}

class EditClassLesson extends EditRecord
{
    protected static string $resource = ClassLessonResource::class;
}
