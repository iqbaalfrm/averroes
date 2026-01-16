<?php

return [
    'column_toggle' => [
        'heading' => 'Kolom',
    ],
    'columns' => [
        'actions' => [
            'label' => 'Aksi|Aksi',
        ],
        'text' => [
            'actions' => [
                'collapse_list' => 'Tampilkan :count lebih sedikit',
                'expand_list' => 'Tampilkan :count lagi',
            ],
            'more_list_items' => 'dan :count lagi',
        ],
    ],
    'fields' => [
        'bulk_select_page' => [
            'label' => 'Pilih/batalkan semua item untuk aksi massal.',
        ],
        'bulk_select_record' => [
            'label' => 'Pilih/batalkan item :key untuk aksi massal.',
        ],
        'bulk_select_group' => [
            'label' => 'Pilih/batalkan grup :title untuk aksi massal.',
        ],
        'search' => [
            'label' => 'Cari',
            'placeholder' => 'Cari',
            'indicator' => 'Cari',
        ],
    ],
    'summary' => [
        'heading' => 'Ringkasan',
        'subheadings' => [
            'all' => 'Semua :label',
            'group' => 'Ringkasan :group',
            'page' => 'Halaman ini',
        ],
        'summarizers' => [
            'average' => [
                'label' => 'Rata-rata',
            ],
            'count' => [
                'label' => 'Jumlah',
            ],
            'sum' => [
                'label' => 'Total',
            ],
        ],
    ],
    'actions' => [
        'disable_reordering' => [
            'label' => 'Selesai mengurutkan data',
        ],
        'enable_reordering' => [
            'label' => 'Urutkan data',
        ],
        'filter' => [
            'label' => 'Saring',
        ],
        'group' => [
            'label' => 'Kelompok',
        ],
        'open_bulk_actions' => [
            'label' => 'Aksi massal',
        ],
        'toggle_columns' => [
            'label' => 'Tampilkan kolom',
        ],
    ],
    'empty' => [
        'heading' => 'Data belum tersedia',
        'description' => 'Tambahkan :model untuk memulai.',
    ],
    'filters' => [
        'actions' => [
            'apply' => [
                'label' => 'Terapkan saring',
            ],
            'remove' => [
                'label' => 'Hapus saring',
            ],
            'remove_all' => [
                'label' => 'Hapus semua saring',
                'tooltip' => 'Hapus semua saring',
            ],
            'reset' => [
                'label' => 'Atur ulang',
            ],
        ],
        'heading' => 'Saring',
        'indicator' => 'Saring aktif',
        'multi_select' => [
            'placeholder' => 'Semua',
        ],
        'select' => [
            'placeholder' => 'Semua',
        ],
        'trashed' => [
            'label' => 'Data terhapus',
            'only_trashed' => 'Hanya data terhapus',
            'with_trashed' => 'Dengan data terhapus',
            'without_trashed' => 'Tanpa data terhapus',
        ],
    ],
    'grouping' => [
        'fields' => [
            'group' => [
                'label' => 'Kelompokkan berdasarkan',
                'placeholder' => 'Kelompokkan berdasarkan',
            ],
            'direction' => [
                'label' => 'Arah kelompok',
                'options' => [
                    'asc' => 'Naik',
                    'desc' => 'Turun',
                ],
            ],
        ],
    ],
    'reorder_indicator' => 'Seret dan lepas data untuk mengurutkan.',
    'selection_indicator' => [
        'selected_count' => '1 data terpilih|:count data terpilih',
        'actions' => [
            'select_all' => [
                'label' => 'Pilih semua :count',
            ],
            'deselect_all' => [
                'label' => 'Batalkan semua',
            ],
        ],
    ],
    'sorting' => [
        'fields' => [
            'column' => [
                'label' => 'Urutkan berdasarkan',
            ],
            'direction' => [
                'label' => 'Arah urut',
                'options' => [
                    'asc' => 'Naik',
                    'desc' => 'Turun',
                ],
            ],
        ],
    ],
];
