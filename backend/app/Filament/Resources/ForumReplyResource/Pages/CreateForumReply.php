<?php

namespace App\Filament\Resources\ForumReplyResource\Pages;

use App\Filament\Resources\ForumReplyResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateForumReply extends CreateRecord
{
    protected static string $resource = ForumReplyResource::class;
    protected static ?string $title = 'Tambah Balasan Diskusi';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
