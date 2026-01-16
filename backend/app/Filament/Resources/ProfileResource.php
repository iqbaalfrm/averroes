<?php

namespace App\Filament\Resources;

use App\Filament\Resources\ProfileResource\Pages;
use App\Filament\Support\RoleHelper;
use App\Models\Profile;
use Filament\Forms\Form;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Resources\Resource;
use Filament\Tables\Table;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Columns\ToggleColumn;
use Filament\Tables\Actions;

class ProfileResource extends Resource
{
    protected static ?string $model = Profile::class;
    protected static ?string $navigationGroup = 'Pengaturan';
    protected static ?string $navigationIcon = 'heroicon-o-users';
    protected static ?string $navigationLabel = 'Profil Admin';
    protected static ?string $modelLabel = 'Profil Admin';
    protected static ?string $pluralModelLabel = 'Profil Admin';
    protected static ?string $slug = 'profil-admin';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('email')->label('Email')->disabled(),
                TextInput::make('display_name')->label('Nama Tampilan'),
                Toggle::make('email_verified')
                    ->label('Email Terverifikasi')
                    ->dehydrated(false),
                Select::make('role')
                    ->label('Peran')
                    ->options([
                        'admin' => 'admin',
                        'editor' => 'editor',
                        'moderator' => 'moderator',
                        'user' => 'user',
                    ])
                    ->required(),
                Toggle::make('is_banned')->label('Diblokir'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('email')->label('Email')->searchable(),
                TextColumn::make('display_name')->label('Nama Tampilan')->searchable(),
                TextColumn::make('role')->label('Peran')->sortable(),
                TextColumn::make('user.email_verified_at')
                    ->label('Verifikasi')
                    ->formatStateUsing(fn ($state) => $state ? 'Terverifikasi' : 'Belum')
                    ->badge(),
                ToggleColumn::make('is_banned')->label('Diblokir'),
                TextColumn::make('created_at')->label('Dibuat')->dateTime()->sortable(),
            ])
            ->actions([
                Actions\ViewAction::make(),
                Actions\EditAction::make(),
                Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Actions\DeleteBulkAction::make(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListProfiles::route('/'),
            'create' => Pages\CreateProfile::route('/create'),
            'view' => Pages\ViewProfile::route('/{record}'),
            'edit' => Pages\EditProfile::route('/{record}/edit'),
        ];
    }
}
