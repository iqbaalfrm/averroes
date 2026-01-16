<?php

namespace App\Filament\Widgets;

use App\Models\User;
use Filament\Tables\Columns\TextColumn;
use Filament\Widgets\TableWidget as BaseWidget;
use Illuminate\Database\Eloquent\Builder;

class RecentUsers extends BaseWidget
{
    protected int|string|array $columnSpan = 'full';

    protected function getTableQuery(): Builder
    {
        return User::query()->orderByDesc('created_at')->limit(10);
    }

    protected function getTableColumns(): array
    {
        return [
            TextColumn::make('email')->label('Email')->searchable(),
            TextColumn::make('created_at')->label('Dibuat')->dateTime(),
        ];
    }
}
