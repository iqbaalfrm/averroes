<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EmailOtp;
use App\Models\Profile;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Validation\Rules\Password as PasswordRule;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'min:8', PasswordRule::defaults()],
            'name' => ['nullable', 'string', 'max:120'],
        ]);

        $user = User::create([
            'name' => $data['name'] ?? null,
            'email' => $data['email'],
            'password' => $data['password'],
        ]);

        Profile::create([
            'id' => $user->id,
            'email' => $user->email,
            'display_name' => $user->name ?? $this->deriveDisplayName($user->email),
            'role' => 'user',
        ]);

        $otp = $this->createOtp($user->email);
        $user->sendOtpNotification($otp);

        return response()->json([
            'message' => 'OTP terkirim. Silakan cek email.',
            'resend_cooldown' => 90,
        ], 201);
    }

    public function login(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $user = User::where('email', $data['email'])->first();
        if (! $user || ! Hash::check($data['password'], $user->password)) {
            return response()->json(['message' => 'Email atau password salah.'], 401);
        }

        if ($user->profile?->is_banned) {
            return response()->json(['message' => 'Akun Anda dinonaktifkan.'], 403);
        }

        if (! $user->hasVerifiedEmail()) {
            return response()->json([
                'code' => 'EMAIL_NOT_VERIFIED',
                'message' => 'Email belum terverifikasi. Masukkan OTP.',
                'verification_required' => true,
            ], 403);
        }

        $token = $user->createToken('api')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $user,
            'profile' => $user->profile,
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => $user,
            'profile' => $user?->profile,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logout berhasil.']);
    }

    public function resendVerification(Request $request)
    {
        return $this->resendOtp($request);
    }

    public function resendOtp(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
        ]);

        $user = User::where('email', $data['email'])->first();
        if (! $user) {
            return response()->json(['message' => 'Email tidak ditemukan.'], 404);
        }

        if ($user->hasVerifiedEmail()) {
            return response()->json(['message' => 'Email sudah terverifikasi.']);
        }

        $rateKey = 'otp-resend:' . sha1($request->ip() . '|' . $user->email);
        if (RateLimiter::tooManyAttempts($rateKey, 5)) {
            return response()->json(['message' => 'Terlalu banyak percobaan. Coba lagi nanti.'], 429);
        }

        $existing = EmailOtp::where('email', $user->email)->latest()->first();
        if ($existing && ! $existing->canResend()) {
            return response()->json([
                'message' => 'Tunggu sebentar sebelum kirim ulang.',
                'resend_cooldown' => $existing->resendCooldownSeconds(),
            ], 429);
        }

        RateLimiter::hit($rateKey, 60);
        $otp = $this->createOtp($user->email);
        $user->sendOtpNotification($otp);

        return response()->json([
            'message' => 'OTP dikirim ulang.',
            'resend_cooldown' => 90,
        ]);
    }

    public function verifyOtp(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'otp' => ['required', 'string', 'size:6'],
        ]);

        $otp = EmailOtp::where('email', $data['email'])->latest()->first();
        if (! $otp) {
            return response()->json(['message' => 'OTP tidak ditemukan.'], 404);
        }

        if ($otp->attempts >= 5) {
            return response()->json(['message' => 'Terlalu banyak percobaan.'], 429);
        }

        if ($otp->isExpired()) {
            return response()->json(['message' => 'OTP kedaluwarsa.'], 410);
        }

        if (! Hash::check($data['otp'], $otp->code_hash)) {
            $otp->increment('attempts');
            return response()->json(['message' => 'OTP salah.'], 422);
        }

        $user = User::where('email', $data['email'])->first();
        if (! $user) {
            return response()->json(['message' => 'User tidak ditemukan.'], 404);
        }

        if (! $user->hasVerifiedEmail()) {
            $user->forceFill(['email_verified_at' => now()])->save();
        }

        EmailOtp::where('email', $data['email'])->delete();

        $token = $user->createToken('api')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $user,
            'profile' => $user->profile,
        ]);
    }

    public function forgotPassword(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
        ]);

        $status = Password::sendResetLink(['email' => $data['email']]);

        if ($status === Password::RESET_LINK_SENT) {
            return response()->json(['message' => 'Link reset password dikirim ke email.']);
        }

        return response()->json(['message' => 'Email tidak ditemukan.'], 404);
    }

    public function resetPassword(Request $request)
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'token' => ['required', 'string'],
            'password' => ['required', 'min:8', 'confirmed'],
        ]);

        $status = Password::reset(
            $data,
            function (User $user, string $password) {
                $user->forceFill([
                    'password' => Hash::make($password),
                ])->save();

                $user->tokens()->delete();
            }
        );

        if ($status === Password::PASSWORD_RESET) {
            return response()->json(['message' => 'Password berhasil direset.']);
        }

        return response()->json(['message' => 'Token reset tidak valid.'], 400);
    }

    private function deriveDisplayName(string $email): string
    {
        $parts = explode('@', $email);
        return $parts[0] ?: 'User';
    }

    private function createOtp(string $email): string
    {
        EmailOtp::where('email', $email)->delete();

        $otp = (string) random_int(100000, 999999);
        EmailOtp::create([
            'email' => $email,
            'code_hash' => Hash::make($otp),
            'expires_at' => Carbon::now()->addMinutes(10),
            'attempts' => 0,
            'resend_available_at' => Carbon::now()->addSeconds(90),
        ]);

        return $otp;
    }
}
