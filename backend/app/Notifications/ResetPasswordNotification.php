<?php

namespace App\Notifications;

use Illuminate\Auth\Notifications\ResetPassword;
use Illuminate\Notifications\Messages\MailMessage;

class ResetPasswordNotification extends ResetPassword
{
    public function toMail($notifiable)
    {
        $resetUrl = config('app.reset_password_url');

        if ($resetUrl) {
            $resetUrl = rtrim($resetUrl, '/') . '?token=' . $this->token . '&email=' . urlencode($notifiable->getEmailForPasswordReset());
        } else {
            $resetUrl = url(route('password.reset', [
                'token' => $this->token,
                'email' => $notifiable->getEmailForPasswordReset(),
            ], false));
        }

        return (new MailMessage)
            ->subject('Atur Ulang Kata Sandi - Averroes')
            ->greeting('Assalamu\'alaikum,')
            ->line('Kami menerima permintaan pengaturan ulang kata sandi untuk akun Anda.')
            ->action('Atur Ulang Kata Sandi', $resetUrl)
            ->line('Jika Anda tidak meminta pengaturan ulang kata sandi, abaikan email ini.');
    }
}
