<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ZakatRecordResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\ZakatRecord;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class ZakatRecordResource extends Resource
{
    protected static ?string $model = ZakatRecord::class;
    protected static ?string $navigationGroup = 'Zakat';
    protected static ?string $navigationIcon = 'heroicon-o-calculator';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('user_id')->required(),
                TextInput::make('total_assets_idr')->numeric(),
                TextInput::make('gold_price_idr_per_gram')->numeric(),
                TextInput::make('nishab_idr')->numeric(),
                TextInput::make('zakat_due_idr')->numeric(),
                TextInput::make('method'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('user_id')->label('User'),
                TextColumn::make('total_assets_idr')->label('Total'),
                TextColumn::make('zakat_due_idr')->label('Zakat'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListZakatRecords::route('/'),
            'create' => Pages\CreateZakatRecord::route('/create'),
            'edit' => Pages\EditZakatRecord::route('/{record}/edit'),
        ];
    }
}
