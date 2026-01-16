<?php

namespace App\Filament\Resources;

use App\Filament\Resources\EdukasiClassResource\Pages;
use App\Filament\Resources\EdukasiClassResource\RelationManagers;
use App\Models\EdukasiClass;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class EdukasiClassResource extends Resource
{
    protected static ?string $model = EdukasiClass::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Kelas Edukasi';
    protected static ?string $modelLabel = 'Kelas Edukasi';
    protected static ?string $pluralModelLabel = 'Kelas Edukasi';
    protected static ?string $slug = 'kelas-edukasi';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('title')
                    ->label('Judul')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('subtitle')
                    ->label('Subjudul')
                    ->maxLength(255)
                    ->default(null),
                Forms\Components\Select::make('level')
                    ->label('Tingkat')
                    ->options([
                        'pemula' => 'Pemula',
                        'menengah' => 'Menengah',
                        'mahir' => 'Mahir',
                    ])
                    ->required()
                    ->default('pemula'),
                Forms\Components\TextInput::make('duration_text')
                    ->label('Durasi')
                    ->maxLength(255)
                    ->default(null),
                Forms\Components\TextInput::make('lessons_count')
                    ->label('Jumlah Materi')
                    ->required()
                    ->numeric()
                    ->default(0),
                Forms\Components\Textarea::make('description')
                    ->label('Deskripsi')
                    ->columnSpanFull(),
                Forms\Components\Textarea::make('outcomes')
                    ->label('Hasil Pembelajaran')
                    ->columnSpanFull(),
                Forms\Components\TextInput::make('cover_theme')
                    ->label('Tema Sampul')
                    ->maxLength(255)
                    ->default(null),
                Forms\Components\TextInput::make('cover_image_url')
                    ->label('Tautan Sampul')
                    ->maxLength(255)
                    ->default(null),
                Forms\Components\Select::make('status')
                    ->label('Status')
                    ->options([
                        'draf' => 'Draf',
                        'terbit' => 'Terbit',
                    ])
                    ->default('terbit')
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
                Tables\Columns\TextColumn::make('title')
                    ->label('Judul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('subtitle')
                    ->label('Subjudul')
                    ->searchable(),
                Tables\Columns\TextColumn::make('level')
                    ->label('Tingkat')
                    ->searchable(),
                Tables\Columns\TextColumn::make('duration_text')
                    ->label('Durasi')
                    ->searchable(),
                Tables\Columns\TextColumn::make('lessons_count')
                    ->label('Jumlah Materi')
                    ->numeric()
                    ->sortable(),
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
            'index' => Pages\ListEdukasiClasses::route('/'),
            'create' => Pages\CreateEdukasiClass::route('/create'),
            'view' => Pages\ViewEdukasiClass::route('/{record}'),
            'edit' => Pages\EditEdukasiClass::route('/{record}/edit'),
        ];
    }
}
