<?php

namespace App\Filament\Resources\ClassModuleResource\Pages;

use App\Filament\Resources\ClassModuleResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateClassModule extends CreateRecord
{
    protected static string $resource = ClassModuleResource::class;
    protected static ?string $title = 'Tambah Modul Kelas';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
