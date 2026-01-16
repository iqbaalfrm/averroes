<?php

namespace App\Filament\Resources;

use App\Filament\Resources\LessonExerciseAttemptResource\Pages;
use App\Models\LessonExerciseAttempt;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class LessonExerciseAttemptResource extends Resource
{
    protected static ?string $model = LessonExerciseAttempt::class;

    protected static ?string $navigationIcon = 'heroicon-o-chart-bar';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Hasil Latihan';
    protected static ?string $modelLabel = 'Hasil Latihan';
    protected static ?string $pluralModelLabel = 'Hasil Latihan';
    protected static ?string $slug = 'hasil-latihan';

    public static function form(Form $form): Form
    {
        return $form->schema([]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('exercise.title')
                    ->label('Latihan')
                    ->searchable(),
                Tables\Columns\TextColumn::make('user.name')
                    ->label('Pengguna')
                    ->searchable(),
                Tables\Columns\TextColumn::make('score')
                    ->label('Nilai')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('status')
                    ->label('Status')
                    ->searchable(),
                Tables\Columns\TextColumn::make('finished_at')
                    ->label('Selesai')
                    ->dateTime()
                    ->sortable(),
            ])
            ->actions([
                Tables\Actions\ViewAction::make(),
            ])
            ->bulkActions([]);
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListLessonExerciseAttempts::route('/'),
            'view' => Pages\ViewLessonExerciseAttempt::route('/{record}'),
        ];
    }
}
