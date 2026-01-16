<?php

namespace App\Filament\Resources\PortfolioAssetResource\Pages;

use App\Filament\Resources\PortfolioAssetResource;
use Filament\Resources\Pages\ViewRecord;

class ViewPortfolioAsset extends ViewRecord
{
    protected static string $resource = PortfolioAssetResource::class;
    protected static ?string $title = 'Detail Aset Portofolio';
    protected static ?string $breadcrumb = 'Detail';
}
