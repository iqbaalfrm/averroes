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
            ->subject('Kode OTP Averroes')
            ->greeting('Assalamu\'alaikum,')
            ->line('Berikut kode verifikasi untuk akun Averroes kamu:')
            ->line("**{$this->otp}**")
            ->line('Kode ini berlaku 10 menit. Jangan berikan kode ini ke siapa pun.')
            ->line('Jika kamu tidak merasa mendaftar, abaikan email ini.');
    }
}
