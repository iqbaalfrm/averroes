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

class ProfileResource extends Resource
{
    protected static ?string $model = Profile::class;
    protected static ?string $navigationGroup = 'Sistem';
    protected static ?string $navigationIcon = 'heroicon-o-users';
    protected static ?string $navigationLabel = 'Users';

    public static function canViewAny(): bool
    {
        return RoleHelper::hasRole(['admin']);
    }

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                TextInput::make('email')->disabled(),
                TextInput::make('display_name')->label('Display Name'),
                Toggle::make('email_verified')
                    ->label('Email Verified')
                    ->dehydrated(false),
                Select::make('role')
                    ->options([
                        'admin' => 'admin',
                        'editor' => 'editor',
                        'moderator' => 'moderator',
                        'user' => 'user',
                    ])
                    ->required(),
                Toggle::make('is_banned')->label('Banned'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('email')->searchable(),
                TextColumn::make('display_name')->label('Display Name')->searchable(),
                TextColumn::make('role')->sortable(),
                TextColumn::make('user.email_verified_at')
                    ->label('Verified')
                    ->formatStateUsing(fn ($state) => $state ? 'Terverifikasi' : 'Belum')
                    ->badge(),
                ToggleColumn::make('is_banned')->label('Banned'),
                TextColumn::make('created_at')->dateTime()->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListProfiles::route('/'),
            'edit' => Pages\EditProfile::route('/{record}/edit'),
        ];
    }
}
