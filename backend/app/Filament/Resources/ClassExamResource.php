<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassExamResource\Pages;
use App\Filament\Resources\ClassExamResource\RelationManagers;
use App\Models\ClassExam;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class ClassExamResource extends Resource
{
    protected static ?string $model = ClassExam::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Ujian Akhir';
    protected static ?string $modelLabel = 'Ujian Akhir';
    protected static ?string $pluralModelLabel = 'Ujian Akhir';
    protected static ?string $slug = 'ujian-akhir';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('class_id')
                    ->label('Kelas')
                    ->relationship('eduClass', 'title')
                    ->searchable()
                    ->required(),
                Forms\Components\TextInput::make('title')
                    ->label('Judul')
                    ->required()
                    ->maxLength(255),
                Forms\Components\Textarea::make('description')
                    ->label('Deskripsi')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('passing_score')
                    ->label('Nilai Lulus')
                    ->numeric()
                    ->required()
                    ->default(70),
                Forms\Components\TextInput::make('duration_min')
                    ->label('Durasi (menit)')
                    ->numeric()
                    ->default(null),
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
                Tables\Columns\TextColumn::make('eduClass.title')
                    ->label('Kelas')
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
            RelationManagers\ClassExamQuestionsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListClassExams::route('/'),
            'create' => Pages\CreateClassExam::route('/create'),
            'view' => Pages\ViewClassExam::route('/{record}'),
            'edit' => Pages\EditClassExam::route('/{record}/edit'),
        ];
    }
}
