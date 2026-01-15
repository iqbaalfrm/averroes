<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassModuleResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\ClassModule;
use App\Models\EdukasiClass;
use Filament\Forms\Form;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class ClassModuleResource extends Resource
{
    protected static ?string $model = ClassModule::class;
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationIcon = 'heroicon-o-rectangle-stack';
    protected static ?string $navigationLabel = 'Modules';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'editor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Select::make('class_id')
                    ->label('Class')
                    ->options(EdukasiClass::query()->pluck('title', 'id'))
                    ->searchable()
                    ->required(),
                TextInput::make('title')->required(),
                TextInput::make('sort_order')->numeric(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')->searchable(),
                TextColumn::make('class_id')->label('Class ID'),
                TextColumn::make('sort_order')->sortable(),
            ])
            ->defaultSort('sort_order');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListClassModules::route('/'),
            'create' => Pages\CreateClassModule::route('/create'),
            'edit' => Pages\EditClassModule::route('/{record}/edit'),
        ];
    }
}
