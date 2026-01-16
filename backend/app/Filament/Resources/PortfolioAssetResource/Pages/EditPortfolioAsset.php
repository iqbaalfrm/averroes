<?php

namespace App\Filament\Resources\PortfolioAssetResource\Pages;

use App\Filament\Resources\PortfolioAssetResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditPortfolioAsset extends EditRecord
{
    protected static string $resource = PortfolioAssetResource::class;
    protected static ?string $title = 'Ubah Aset Portofolio';
    protected static ?string $breadcrumb = 'Ubah';

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make()
                ->label('Hapus')
                ->modalHeading('Hapus Aset Portofolio')
                ->modalDescription('Apakah Anda yakin?')
                ->successNotificationTitle('Berhasil dihapus'),
        ];
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
