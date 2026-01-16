<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassExamAttemptResource\Pages;
use App\Models\ClassExamAttempt;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class ClassExamAttemptResource extends Resource
{
    protected static ?string $model = ClassExamAttempt::class;

    protected static ?string $navigationIcon = 'heroicon-o-clipboard-document';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Hasil Ujian';
    protected static ?string $modelLabel = 'Hasil Ujian';
    protected static ?string $pluralModelLabel = 'Hasil Ujian';
    protected static ?string $slug = 'hasil-ujian';

    public static function form(Form $form): Form
    {
        return $form->schema([]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('exam.eduClass.title')
                    ->label('Kelas')
                    ->searchable(),
                Tables\Columns\TextColumn::make('exam.title')
                    ->label('Ujian')
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
            'index' => Pages\ListClassExamAttempts::route('/'),
            'view' => Pages\ViewClassExamAttempt::route('/{record}'),
        ];
    }
}
