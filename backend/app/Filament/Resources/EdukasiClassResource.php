<?php

namespace App\Filament\Resources;

use App\Filament\Resources\EdukasiClassResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\EdukasiClass;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TagsInput;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class EdukasiClassResource extends Resource
{
    protected static ?string $model = EdukasiClass::class;
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';
    protected static ?string $navigationLabel = 'Classes';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'editor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('title')->required(),
                TextInput::make('subtitle'),
                Select::make('level')
                    ->options([
                        'Pemula' => 'Pemula',
                        'Menengah' => 'Menengah',
                        'Mahir' => 'Mahir',
                    ])
                    ->required(),
                TextInput::make('duration_text')->label('Duration'),
                TextInput::make('lessons_count')->numeric(),
                Textarea::make('description')->rows(3),
                TagsInput::make('outcomes'),
                TextInput::make('cover_theme'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')->searchable(),
                TextColumn::make('level')->sortable(),
                TextColumn::make('duration_text')->label('Duration'),
                TextColumn::make('lessons_count')->label('Lessons'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListEdukasiClasses::route('/'),
            'create' => Pages\CreateEdukasiClass::route('/create'),
            'edit' => Pages\EditEdukasiClass::route('/{record}/edit'),
        ];
    }
}
