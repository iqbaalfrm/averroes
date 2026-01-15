<?php

namespace App\Filament\Support;

use Illuminate\Support\Facades\Auth;

class RoleHelper
{
    public static function hasRole(array $roles): bool
    {
        $user = Auth::user();
        $role = $user?->profile?->role;

        return $role !== null && in_array($role, $roles, true);
    }
}
