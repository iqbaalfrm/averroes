<?php

namespace App\Filament\Resources\ProfileResource\Pages;

use App\Filament\Resources\ProfileResource;
use Filament\Resources\Pages\EditRecord;

class EditProfile extends EditRecord
{
    protected static string $resource = ProfileResource::class;
    protected static ?string $title = 'Ubah Profil Admin';
    protected static ?string $breadcrumb = 'Ubah';

    protected function mutateFormDataBeforeFill(array $data): array
    {
        $data['email_verified'] = (bool) ($this->record->user?->email_verified_at);
        return $data;
    }

    protected function afterSave(): void
    {
        $shouldBeVerified = (bool) ($this->data['email_verified'] ?? false);
        $user = $this->record->user;
        if (! $user) {
            return;
        }

        if ($shouldBeVerified && ! $user->hasVerifiedEmail()) {
            $user->forceFill(['email_verified_at' => now()])->save();
        }

        if (! $shouldBeVerified && $user->hasVerifiedEmail()) {
            $user->forceFill(['email_verified_at' => null])->save();
        }
    }

    protected function getSavedNotificationTitle(): ?string
    {
        return 'Berhasil disimpan';
    }
}
