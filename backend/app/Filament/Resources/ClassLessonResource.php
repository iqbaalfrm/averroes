<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassLessonResource\Pages;
use App\Filament\Resources\ClassLessonResource\RelationManagers;
use App\Models\ClassLesson;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class ClassLessonResource extends Resource
{
    protected static ?string $model = ClassLesson::class;

    protected static ?string $navigationIcon = 'heroicon-o-document-text';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Materi Kelas';
    protected static ?string $modelLabel = 'Materi Kelas';
    protected static ?string $pluralModelLabel = 'Materi Kelas';
    protected static ?string $slug = 'materi-kelas';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('class_id')
                    ->label('Kelas')
                    ->relationship('eduClass', 'title')
                    ->searchable()
                    ->required(),
                Forms\Components\Select::make('module_id')
                    ->label('Modul')
                    ->relationship('module', 'title')
                    ->searchable()
                    ->required(),
                Forms\Components\TextInput::make('title')
                    ->label('Judul')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Select::make('type')
                    ->label('Jenis')
                    ->options([
                        'baca' => 'Bacaan',
                        'video' => 'Video',
                        'audio' => 'Audio',
                    ])
                    ->required()
                    ->default('baca'),
                Forms\Components\TextInput::make('duration_min')
                    ->label('Durasi (menit)')
                    ->required()
                    ->numeric()
                    ->default(0),
                Forms\Components\Textarea::make('content')
                    ->label('Konten')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('ayat_reference')
                    ->label('Referensi Ayat')
                    ->maxLength(255),
                Forms\Components\Textarea::make('ayat_arabic')
                    ->label('Ayat (Arab)')
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('ayat_translation')
                    ->label('Terjemahan Ayat')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('media_url')
                    ->label('Tautan Media')
                    ->maxLength(255)
                    ->default(null),
                Forms\Components\TextInput::make('sort_order')
                    ->label('Urutan')
                    ->required()
                    ->numeric()
                    ->default(0),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('id')
                    ->label('ID')
                    ->searchable(),
                Tables\Columns\TextColumn::make('eduClass.title')
                    ->label('Kelas')
                    ->searchable(),
                Tables\Columns\TextColumn::make('module.title')
                    ->label('Modul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('title')
                    ->label('Judul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('Jenis')
                    ->searchable(),
                Tables\Columns\TextColumn::make('duration_min')
                    ->label('Durasi')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('sort_order')
                    ->label('Urutan')
                    ->numeric()
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
            'index' => Pages\ListClassLessons::route('/'),
            'create' => Pages\CreateClassLesson::route('/create'),
            'view' => Pages\ViewClassLesson::route('/{record}'),
            'edit' => Pages\EditClassLesson::route('/{record}/edit'),
        ];
    }
}
