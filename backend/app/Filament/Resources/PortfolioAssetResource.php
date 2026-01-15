<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PortfolioAssetResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\PortfolioAsset;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class PortfolioAssetResource extends Resource
{
    protected static ?string $model = PortfolioAsset::class;
    protected static ?string $navigationGroup = 'Portfolio';
    protected static ?string $navigationIcon = 'heroicon-o-banknotes';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('user_id')->required(),
                TextInput::make('coin_code')->required(),
                TextInput::make('coin_name')->required(),
                TextInput::make('network'),
                TextInput::make('amount')->numeric()->required(),
                TextInput::make('avg_buy_price_usd')->numeric(),
                TextInput::make('notes'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('coin_code')->sortable(),
                TextColumn::make('coin_name')->sortable(),
                TextColumn::make('amount'),
                TextColumn::make('user_id')->label('User'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListPortfolioAssets::route('/'),
            'create' => Pages\CreatePortfolioAsset::route('/create'),
            'edit' => Pages\EditPortfolioAsset::route('/{record}/edit'),
        ];
    }
}
