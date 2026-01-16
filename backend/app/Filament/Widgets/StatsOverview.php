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
            Stat::make('Total Pengguna', User::count()),
            Stat::make('Total Artikel', Article::count()),
            Stat::make('Total Diskusi', ForumThread::count()),
            Stat::make('Total Kelas', EdukasiClass::count()),
        ];
    }
}
