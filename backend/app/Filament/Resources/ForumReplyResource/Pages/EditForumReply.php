<?php

namespace App\Filament\Resources\ForumReplyResource\Pages;

use App\Filament\Resources\ForumReplyResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditForumReply extends EditRecord
{
    protected static string $resource = ForumReplyResource::class;
    protected static ?string $title = 'Ubah Balasan Diskusi';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Balasan Diskusi')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
