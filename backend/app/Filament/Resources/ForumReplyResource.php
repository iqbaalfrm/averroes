<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ForumReplyResource\Pages;
use App\Filament\Resources\ForumReplyResource\RelationManagers;
use App\Models\ForumReply;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ForumReplyResource extends Resource
{
    protected static ?string $model = ForumReply::class;

    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left';
    protected static ?string $navigationGroup = 'Diskusi';
    protected static ?string $navigationLabel = 'Balasan Diskusi';
    protected static ?string $modelLabel = 'Balasan Diskusi';
    protected static ?string $pluralModelLabel = 'Balasan Diskusi';
    protected static ?string $slug = 'balasan-diskusi';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('thread_id')
                    ->label('Diskusi')
                    ->required()
                    ->maxLength(36),
                Forms\Components\TextInput::make('user_id')
                    ->label('Pengguna')
                    ->maxLength(36)
                    ->default(null),
                Forms\Components\Textarea::make('body')
                    ->label('Isi Balasan')
                    ->required()
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('like_count')
                    ->label('Jumlah Suka')
                    ->required()
                    ->numeric()
                    ->default(0),
                Forms\Components\Toggle::make('is_accepted')
                    ->label('Diterima')
                    ->required(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->searchable(),
                Tables\Columns\TextColumn::make('thread_id')
                    ->label('Diskusi')
                    ->searchable(),
                Tables\Columns\TextColumn::make('user_id')
                    ->label('Pengguna')
                    ->searchable(),
                Tables\Columns\TextColumn::make('like_count')
                    ->label('Suka')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\IconColumn::make('is_accepted')
                    ->label('Diterima')
                    ->boolean(),
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
            'index' => Pages\ListForumReplies::route('/'),
            'create' => Pages\CreateForumReply::route('/create'),
            'view' => Pages\ViewForumReply::route('/{record}'),
            'edit' => Pages\EditForumReply::route('/{record}/edit'),
        ];
    }
}
