<?php

namespace App\Filament\Resources\ClassLessonResource\Pages;

use App\Filament\Resources\ClassLessonResource;
use Filament\Resources\Pages\ViewRecord;

class ViewClassLesson extends ViewRecord
{
    protected static string $resource = ClassLessonResource::class;
    protected static ?string $title = 'Detail Materi Kelas';
    protected static ?string $breadcrumb = 'Detail';
}
