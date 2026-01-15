<?php

namespace Database\Seeders;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminUserSeeder extends Seeder
{
    public function run(): void
    {
        $email = env('ADMIN_EMAIL', 'admin@averroes.web.id');
        $password = env('ADMIN_PASSWORD', 'Admin123!');

        $user = User::firstOrCreate(
            ['email' => $email],
            [
                'name' => 'Admin Averroes',
                'password' => Hash::make($password),
                'email_verified_at' => now(),
            ]
        );

        Profile::updateOrCreate(
            ['id' => $user->id],
            [
                'email' => $user->email,
                'display_name' => $user->name,
                'role' => 'admin',
                'is_banned' => false,
            ]
        );
    }
}
