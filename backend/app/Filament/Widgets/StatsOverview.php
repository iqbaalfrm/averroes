<?php

namespace App\Filament\Widgets;

use App\Models\Article;
use App\Models\EdukasiClass;
use App\Models\ForumThread;
use App\Models\User;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        return [
            Stat::make('Total Users', User::count()),
            Stat::make('Total Articles', Article::count()),
            Stat::make('Total Threads', ForumThread::count()),
            Stat::make('Total Classes', EdukasiClass::count()),
        ];
    }
}
