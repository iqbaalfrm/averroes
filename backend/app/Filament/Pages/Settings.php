<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;
use App\Filament\Support\RoleHelper;

class Settings extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-cog-6-tooth';
    protected static ?string $navigationGroup = 'Pengaturan';
    protected static ?string $navigationLabel = 'Pengaturan';
    protected static ?string $slug = 'pengaturan';
    protected static ?string $title = 'Pengaturan';
    protected static string $view = 'filament.pages.settings';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin']);
    }
}
