<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ForumThreadResource\Pages;
use App\Filament\Resources\ForumThreadResource\RelationManagers;
use App\Models\ForumThread;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ForumThreadResource extends Resource
{
    protected static ?string $model = ForumThread::class;

    protected static ?string $navigationIcon = 'heroicon-o-chat-bubble-left-right';
    protected static ?string $navigationGroup = 'Diskusi';
    protected static ?string $navigationLabel = 'Diskusi';
    protected static ?string $modelLabel = 'Diskusi';
    protected static ?string $pluralModelLabel = 'Diskusi';
    protected static ?string $slug = 'diskusi';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('user_id')
                    ->label('Pengguna')
                    ->maxLength(36)
                    ->default(null),
                Forms\Components\Toggle::make('is_anonymous')
                    ->label('Anonim')
                    ->required(),
                Forms\Components\TextInput::make('category')
                    ->label('Kategori')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('title')
                    ->label('Judul')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Textarea::make('body')
                    ->label('Isi Diskusi')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('reply_count')
                    ->label('Jumlah Balasan')
                    ->required()
                    ->numeric()
                    ->default(0),
                Forms\Components\TextInput::make('like_count')
                    ->label('Jumlah Suka')
                    ->required()
                    ->numeric()
                    ->default(0),
                Forms\Components\Toggle::make('is_hidden')
                    ->label('Disembunyikan')
                    ->required(),
                Forms\Components\Toggle::make('is_locked')
                    ->label('Dikunci')
                    ->required(),
                Forms\Components\Select::make('status')
                    ->label('Status')
                    ->options([
                        'terbuka' => 'Terbuka',
                        'ditutup' => 'Ditutup',
                    ])
                    ->default('terbuka')
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
                Tables\Columns\TextColumn::make('user_id')
                    ->label('Pengguna')
                    ->searchable(),
                Tables\Columns\IconColumn::make('is_anonymous')
                    ->label('Anonim')
                    ->boolean(),
                Tables\Columns\TextColumn::make('category')
                    ->label('Kategori')
                    ->searchable(),
                Tables\Columns\TextColumn::make('title')
                    ->label('Judul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('reply_count')
                    ->label('Balasan')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('like_count')
                    ->label('Suka')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\IconColumn::make('is_hidden')
                    ->label('Disembunyikan')
                    ->boolean(),
                Tables\Columns\IconColumn::make('is_locked')
                    ->label('Dikunci')
                    ->boolean(),
                Tables\Columns\TextColumn::make('status')
                    ->label('Status')
                    ->sortable(),
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
            'index' => Pages\ListForumThreads::route('/'),
            'create' => Pages\CreateForumThread::route('/create'),
            'view' => Pages\ViewForumThread::route('/{record}'),
            'edit' => Pages\EditForumThread::route('/{record}/edit'),
        ];
    }
}
