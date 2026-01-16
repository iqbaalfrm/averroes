<?php

namespace App\Filament\Resources\ForumThreadResource\Pages;

use App\Filament\Resources\ForumThreadResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateForumThread extends CreateRecord
{
    protected static string $resource = ForumThreadResource::class;
    protected static ?string $title = 'Tambah Diskusi';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
