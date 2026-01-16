<?php

namespace App\Notifications;

use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class EmailOtpNotification extends Notification
{
    public function __construct(private readonly string $otp)
    {
    }

    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Kode Verifikasi Averroes')
            ->greeting('Assalamu\'alaikum,')
            ->line('Kode verifikasi akun Averroes Anda adalah:')
            ->line("**{$this->otp}**")
            ->line('Jangan bagikan kode ini kepada siapa pun.')
            ->line('Jika Anda tidak merasa mendaftar, abaikan email ini.');
    }
}
