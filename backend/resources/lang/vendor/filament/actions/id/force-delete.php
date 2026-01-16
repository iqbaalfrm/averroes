<?php

return [
    'single' => [
        'label' => 'Hapus permanen',
        'modal' => [
            'heading' => 'Hapus permanen :label',
            'actions' => [
                'force_delete' => [
                    'label' => 'Hapus permanen',
                ],
            ],
        ],
        'notifications' => [
            'force_deleted' => [
                'title' => 'Berhasil dihapus',
            ],
        ],
    ],
    'multiple' => [
        'label' => 'Hapus permanen terpilih',
        'modal' => [
            'heading' => 'Hapus permanen :label terpilih',
            'actions' => [
                'force_delete' => [
                    'label' => 'Hapus permanen',
                ],
            ],
        ],
        'notifications' => [
            'force_deleted' => [
                'title' => 'Berhasil dihapus',
            ],
        ],
    ],
];
