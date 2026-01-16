<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ClassCertificateResource\Pages;
use App\Models\ClassCertificate;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class ClassCertificateResource extends Resource
{
    protected static ?string $model = ClassCertificate::class;

    protected static ?string $navigationIcon = 'heroicon-o-document-duplicate';
    protected static ?string $navigationGroup = 'Edukasi';
    protected static ?string $navigationLabel = 'Sertifikat';
    protected static ?string $modelLabel = 'Sertifikat';
    protected static ?string $pluralModelLabel = 'Sertifikat';
    protected static ?string $slug = 'sertifikat';

    public static function form(Form $form): Form
    {
        return $form->schema([]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('certificate_number')
                    ->label('Nomor Sertifikat')
                    ->searchable(),
                Tables\Columns\TextColumn::make('eduClass.title')
                    ->label('Kelas')
                    ->searchable(),
                Tables\Columns\TextColumn::make('user.name')
                    ->label('Pengguna')
                    ->searchable(),
                Tables\Columns\TextColumn::make('final_score')
                    ->label('Nilai Akhir')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('issued_at')
                    ->label('Tanggal Terbit')
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
            'index' => Pages\ListClassCertificates::route('/'),
            'view' => Pages\ViewClassCertificate::route('/{record}'),
        ];
    }
}
