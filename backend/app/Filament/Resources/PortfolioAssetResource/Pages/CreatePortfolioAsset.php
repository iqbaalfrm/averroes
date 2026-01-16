<?php

namespace App\Filament\Resources\PortfolioAssetResource\Pages;

use App\Filament\Resources\PortfolioAssetResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreatePortfolioAsset extends CreateRecord
{
    protected static string $resource = PortfolioAssetResource::class;
    protected static ?string $title = 'Tambah Aset Portofolio';
    protected static ?string $breadcrumb = 'Tambah';

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
