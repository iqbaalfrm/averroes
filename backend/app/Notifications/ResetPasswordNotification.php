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
            ->subject('Reset Password - Averroes')
            ->greeting('Assalamu\'alaikum,')
            ->line('Kami menerima permintaan reset password untuk akunmu.')
            ->action('Atur Ulang Password', $resetUrl)
            ->line('Jika kamu tidak meminta reset password, abaikan email ini.');
    }
}
