<?php

namespace Database\Seeders;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class OtherUsersSeeder extends Seeder
{
    public function run(): void
    {
        // Password default: Admin123!
        $password = Hash::make('Admin123!');

        // 1. Editor - Panel Access
        $this->createUser(
            'editor@averroes.web.id',
            'Editor Averroes',
            'editor',
            $password
        );

        // 2. Moderator - Panel Access
        $this->createUser(
            'moderator@averroes.web.id',
            'Moderator Averroes',
            'moderator',
            $password
        );

        // 3. Member Legacy (Utama)
        $this->createUser(
            'member@averroes.web.id',
            'Member Utama',
            'member',
            $password
        );

        // 4. Dummy Members
        for ($i = 1; $i <= 5; $i++) {
            $this->createUser(
                "user{$i}@averroes.web.id",
                "User Demo {$i}",
                'member',
                $password
            );
        }
    }

    private function createUser($email, $name, $role, $hashedPassword)
    {
        $user = User::firstOrCreate(
            ['email' => $email],
            [
                'name' => $name,
                'password' => $hashedPassword,
                'email_verified_at' => now(),
            ]
        );

        Profile::updateOrCreate(
            ['id' => $user->id],
            [
                'email' => $user->email,
                'display_name' => $name,
                'role' => $role,
                'is_banned' => false,
            ]
        );
    }
}
