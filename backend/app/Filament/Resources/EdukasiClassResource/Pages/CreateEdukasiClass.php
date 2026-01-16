<?php

namespace App\Filament\Resources\EdukasiClassResource\Pages;

use App\Filament\Resources\EdukasiClassResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateEdukasiClass extends CreateRecord
{
    protected static string $resource = EdukasiClassResource::class;
    protected static ?string $title = 'Tambah Kelas Edukasi';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
