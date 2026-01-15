<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ArticleResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\Article;
use Filament\Forms\Form;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\DateTimePicker;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;

class ArticleResource extends Resource
{
    protected static ?string $model = Article::class;
    protected static ?string $navigationGroup = 'Artikel';
    protected static ?string $navigationIcon = 'heroicon-o-newspaper';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'editor']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('title')->required(),
                TextInput::make('slug'),
                Textarea::make('excerpt')->rows(3),
                Textarea::make('content')->rows(6),
                TextInput::make('cover_image_url')->label('Cover Image URL'),
                TextInput::make('source')->required(),
                TextInput::make('url')->required(),
                TextInput::make('image_url')->label('Image URL'),
                Select::make('status')
                    ->options([
                        'draft' => 'Draft',
                        'published' => 'Published',
                    ])
                    ->default('published'),
                DateTimePicker::make('published_at')->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')->searchable()->limit(40),
                TextColumn::make('source')->sortable(),
                TextColumn::make('status')->sortable(),
                TextColumn::make('published_at')->dateTime()->sortable(),
            ])
            ->defaultSort('published_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListArticles::route('/'),
            'create' => Pages\CreateArticle::route('/create'),
            'edit' => Pages\EditArticle::route('/{record}/edit'),
        ];
    }
}
