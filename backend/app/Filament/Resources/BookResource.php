<?php

namespace App\Filament\Resources;

use App\Filament\Resources\BookResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\Book;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class BookResource extends Resource
{
    protected static ?string $model = Book::class;
    protected static ?string $navigationGroup = 'Pustaka';
    protected static ?string $navigationIcon = 'heroicon-o-book-open';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'editor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('display_title')->required(),
                TextInput::make('original_title')->required(),
                TextInput::make('author'),
                TextInput::make('language'),
                TextInput::make('category'),
                TextInput::make('pages')->numeric(),
                Textarea::make('description')->rows(4),
                TextInput::make('pdf_url')->required(),
                TextInput::make('cover_url'),
                TextInput::make('cover_image_url')->label('Cover Image URL'),
                TextInput::make('status')->default('published'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('display_title')->label('Title')->searchable(),
                TextColumn::make('author')->sortable(),
                TextColumn::make('category')->sortable(),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListBooks::route('/'),
            'create' => Pages\CreateBook::route('/create'),
            'edit' => Pages\EditBook::route('/{record}/edit'),
        ];
    }
}
