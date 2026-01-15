<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ForumThreadResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\ForumThread;
use Filament\Forms\Form;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ToggleColumn;

class ForumThreadResource extends Resource
{
    protected static ?string $model = ForumThread::class;
    protected static ?string $navigationGroup = 'Diskusi';
    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left-right';
    protected static ?string $navigationLabel = 'Threads';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'moderator']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('title')->required(),
                TextInput::make('category')->required(),
                Textarea::make('body')->rows(4),
                Toggle::make('is_hidden'),
                Toggle::make('is_locked'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')->searchable()->limit(40),
                TextColumn::make('category')->sortable(),
                TextColumn::make('reply_count')->label('Replies'),
                TextColumn::make('like_count')->label('Likes'),
                ToggleColumn::make('is_hidden'),
                ToggleColumn::make('is_locked'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListForumThreads::route('/'),
            'edit' => Pages\EditForumThread::route('/{record}/edit'),
        ];
    }
}
