<?php

namespace App\Filament\Resources;

use App\Filament\Resources\LessonExerciseResource\Pages;
use App\Filament\Resources\LessonExerciseResource\RelationManagers;
use App\Models\LessonExercise;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class LessonExerciseResource extends Resource
{
    protected static ?string $model = LessonExercise::class;

    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document-check';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Latihan Materi';
    protected static ?string $modelLabel = 'Latihan Materi';
    protected static ?string $pluralModelLabel = 'Latihan Materi';
    protected static ?string $slug = 'latihan-materi';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('lesson_id')
                    ->label('Materi')
                    ->relationship('lesson', 'title')
                    ->searchable()
                    ->required(),
                Forms\Components\TextInput::make('title')
                    ->label('Judul')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Textarea::make('instructions')
                    ->label('Instruksi')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('passing_score')
                    ->label('Nilai Lulus')
                    ->numeric()
                    ->required()
                    ->default(70),
                Forms\Components\TextInput::make('max_attempts')
                    ->label('Batas Percobaan')
                    ->numeric()
                    ->default(null),
                Forms\Components\Toggle::make('is_active')
                    ->label('Aktif')
                    ->default(true),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('lesson.title')
                    ->label('Materi')
                    ->searchable(),
                Tables\Columns\TextColumn::make('title')
                    ->label('Judul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('passing_score')
                    ->label('Nilai Lulus')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\IconColumn::make('is_active')
                    ->label('Aktif')
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
            RelationManagers\LessonExerciseQuestionsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListLessonExercises::route('/'),
            'create' => Pages\CreateLessonExercise::route('/create'),
            'view' => Pages\ViewLessonExercise::route('/{record}'),
            'edit' => Pages\EditLessonExercise::route('/{record}/edit'),
        ];
    }
}
