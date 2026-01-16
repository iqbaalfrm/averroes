<?php

namespace App\Filament\Resources\EdukasiClassResource\Pages;

use App\Filament\Resources\EdukasiClassResource;
use Filament\Resources\Pages\ViewRecord;

class ViewEdukasiClass extends ViewRecord
{
    protected static string $resource = EdukasiClassResource::class;
    protected static ?string $title = 'Detail Kelas Edukasi';
    protected static ?string $breadcrumb = 'Detail';
}
