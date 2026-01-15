<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ForumReplyResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\ForumReply;
use Filament\Forms\Form;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ToggleColumn;

class ForumReplyResource extends Resource
{
    protected static ?string $model = ForumReply::class;
    protected static ?string $navigationGroup = 'Diskusi';
    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left';
    protected static ?string $navigationLabel = 'Replies';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin', 'moderator']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Textarea::make('body')->rows(4)->required(),
                Toggle::make('is_accepted'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('thread_id')->label('Thread'),
                TextColumn::make('body')->limit(40),
                TextColumn::make('like_count')->label('Likes'),
                ToggleColumn::make('is_accepted'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListForumReplies::route('/'),
            'edit' => Pages\EditForumReply::route('/{record}/edit'),
        ];
    }
}
