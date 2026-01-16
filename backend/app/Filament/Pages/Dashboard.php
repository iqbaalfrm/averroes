<?php

namespace App\Filament\Pages;

use Filament\Pages\Dashboard as BaseDashboard;

class Dashboard extends BaseDashboard
{
    protected static ?string $navigationIcon = 'heroicon-o-squares-2x2';
    protected static ?string $navigationLabel = 'Beranda Admin';
    protected static ?string $title = 'Beranda Admin';
    protected static ?int $navigationSort = 1;
}
