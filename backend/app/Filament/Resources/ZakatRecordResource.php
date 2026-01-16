<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ZakatRecordResource\Pages;
use App\Filament\Resources\ZakatRecordResource\RelationManagers;
use App\Models\ZakatRecord;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ZakatRecordResource extends Resource
{
    protected static ?string $model = ZakatRecord::class;

    protected static ?string $navigationIcon = 'heroicon-o-calculator';
    protected static ?string $navigationGroup = 'Zakat';
    protected static ?string $navigationLabel = 'Perhitungan Zakat';
    protected static ?string $modelLabel = 'Perhitungan Zakat';
    protected static ?string $pluralModelLabel = 'Perhitungan Zakat';
    protected static ?string $slug = 'zakat';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('user_id')
                    ->label('Pengguna')
                    ->required()
                    ->maxLength(36),
                Forms\Components\TextInput::make('total_assets_idr')
                    ->label('Total Aset (IDR)')
                    ->required()
                    ->numeric()
                    ->default(0.00),
                Forms\Components\TextInput::make('gold_price_idr_per_gram')
                    ->label('Harga Emas per Gram (IDR)')
                    ->required()
                    ->numeric()
                    ->default(0.00),
                Forms\Components\TextInput::make('nishab_idr')
                    ->label('Nisab (IDR)')
                    ->required()
                    ->numeric()
                    ->default(0.00),
                Forms\Components\TextInput::make('zakat_due_idr')
                    ->label('Zakat Terhitung (IDR)')
                    ->required()
                    ->numeric()
                    ->default(0.00),
                Forms\Components\TextInput::make('method')
                    ->label('Metode')
                    ->maxLength(255)
                    ->default(null),
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
                Tables\Columns\TextColumn::make('total_assets_idr')
                    ->label('Total Aset')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('gold_price_idr_per_gram')
                    ->label('Harga Emas/Gram')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('nishab_idr')
                    ->label('Nisab')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('zakat_due_idr')
                    ->label('Zakat')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('method')
                    ->label('Metode')
                    ->searchable(),
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
            'index' => Pages\ListZakatRecords::route('/'),
            'create' => Pages\CreateZakatRecord::route('/create'),
            'view' => Pages\ViewZakatRecord::route('/{record}'),
            'edit' => Pages\EditZakatRecord::route('/{record}/edit'),
        ];
    }
}
