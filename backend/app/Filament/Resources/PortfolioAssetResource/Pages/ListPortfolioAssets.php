<?php

namespace App\Filament\Resources\PortfolioAssetResource\Pages;

use App\Filament\Resources\PortfolioAssetResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListPortfolioAssets extends ListRecords
{
    protected static string $resource = PortfolioAssetResource::class;
}

class CreatePortfolioAsset extends CreateRecord
{
    protected static string $resource = PortfolioAssetResource::class;
}

class EditPortfolioAsset extends EditRecord
{
    protected static string $resource = PortfolioAssetResource::class;
}
