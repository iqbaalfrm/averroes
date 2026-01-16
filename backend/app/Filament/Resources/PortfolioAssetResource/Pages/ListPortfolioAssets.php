<?php

namespace App\Filament\Resources\PortfolioAssetResource\Pages;

use App\Filament\Resources\PortfolioAssetResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListPortfolioAssets extends ListRecords
{
    protected static string $resource = PortfolioAssetResource::class;
    protected static ?string $title = 'Aset Portofolio';
    protected static ?string $breadcrumb = 'Aset Portofolio';

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make()->label('Tambah'),
        ];
    }
}
