<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassLessonResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\ClassLesson;
use App\Models\ClassModule;
use Filament\Forms\Form;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class ClassLessonResource extends Resource
{
    protected static ?string $model = ClassLesson::class;
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationIcon = 'heroicon-o-document-text';
    protected static ?string $navigationLabel = 'Lessons';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'editor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Select::make('module_id')
                    ->label('Module')
                    ->options(ClassModule::query()->pluck('title', 'id'))
                    ->searchable()
                    ->required(),
                TextInput::make('title')->required(),
                Select::make('type')
                    ->options([
                        'reading' => 'reading',
                        'video' => 'video',
                        'audio' => 'audio',
                    ])
                    ->required(),
                TextInput::make('duration_min')->numeric(),
                Textarea::make('content')->rows(4),
                TextInput::make('media_url'),
                TextInput::make('sort_order')->numeric(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')->searchable(),
                TextColumn::make('type'),
                TextColumn::make('duration_min')->label('Duration'),
                TextColumn::make('sort_order')->sortable(),
            ])
            ->defaultSort('sort_order');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListClassLessons::route('/'),
            'create' => Pages\CreateClassLesson::route('/create'),
            'edit' => Pages\EditClassLesson::route('/{record}/edit'),
        ];
    }
}
