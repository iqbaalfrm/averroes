<?php

namespace App\Filament\Resources;

use App\Filament\Resources\PortfolioAssetResource\Pages;
use App\Filament\Resources\PortfolioAssetResource\RelationManagers;
use App\Models\PortfolioAsset;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class PortfolioAssetResource extends Resource
{
    protected static ?string $model = PortfolioAsset::class;

    protected static ?string $navigationIcon = 'heroicon-o-banknotes';
    protected static ?string $navigationGroup = 'Portofolio';
    protected static ?string $navigationLabel = 'Aset Portofolio';
    protected static ?string $modelLabel = 'Aset Portofolio';
    protected static ?string $pluralModelLabel = 'Aset Portofolio';
    protected static ?string $slug = 'aset-portofolio';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('user_id')
                    ->label('Pengguna')
                    ->required()
                    ->maxLength(36),
                Forms\Components\TextInput::make('coin_code')
                    ->label('Kode Aset')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('coin_name')
                    ->label('Nama Aset')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('network')
                    ->label('Jaringan')
                    ->required()
                    ->maxLength(255)
                    ->default('spot'),
                Forms\Components\TextInput::make('amount')
                    ->label('Jumlah')
                    ->required()
                    ->numeric(),
                Forms\Components\TextInput::make('avg_buy_price_usd')
                    ->label('Rata-rata Beli (USD)')
                    ->numeric()
                    ->default(null),
                Forms\Components\Textarea::make('notes')
                    ->label('Catatan')
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->searchable(),
                Tables\Columns\TextColumn::make('user_id')
                    ->label('Pengguna')
                    ->searchable(),
                Tables\Columns\TextColumn::make('coin_code')
                    ->label('Kode Aset')
                    ->searchable(),
                Tables\Columns\TextColumn::make('coin_name')
                    ->label('Nama Aset')
                    ->searchable(),
                Tables\Columns\TextColumn::make('network')
                    ->label('Jaringan')
                    ->searchable(),
                Tables\Columns\TextColumn::make('amount')
                    ->label('Jumlah')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('avg_buy_price_usd')
                    ->label('Rata-rata Beli (USD)')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('Dibuat')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->label('Diperbarui')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListPortfolioAssets::route('/'),
            'create' => Pages\CreatePortfolioAsset::route('/create'),
            'view' => Pages\ViewPortfolioAsset::route('/{record}'),
            'edit' => Pages\EditPortfolioAsset::route('/{record}/edit'),
        ];
    }
}
