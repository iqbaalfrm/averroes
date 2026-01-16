<?php

namespace App\Filament\Resources\ProfileResource\Pages;

use App\Filament\Resources\ProfileResource;
use Filament\Resources\Pages\ViewRecord;

class ViewProfile extends ViewRecord
{
    protected static string $resource = ProfileResource::class;
    protected static ?string $title = 'Detail Profil Admin';
    protected static ?string $breadcrumb = 'Detail';
}
