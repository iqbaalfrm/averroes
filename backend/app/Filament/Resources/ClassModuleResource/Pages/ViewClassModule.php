<?php

namespace App\Filament\Resources\ClassModuleResource\Pages;

use App\Filament\Resources\ClassModuleResource;
use Filament\Resources\Pages\ViewRecord;

class ViewClassModule extends ViewRecord
{
    protected static string $resource = ClassModuleResource::class;
    protected static ?string $title = 'Detail Modul Kelas';
    protected static ?string $breadcrumb = 'Detail';
}
