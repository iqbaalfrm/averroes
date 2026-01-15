<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'http://10.0.2.2',
        'http://localhost',
        'http://127.0.0.1',
        'http://167.99.69.90',
    ],
    'allowed_origins_patterns' => [
        '#^http://(localhost|127\.0\.0\.1|10\.0\.2\.2)(:\\d+)?$#',
        '#^http://167\.99\.69\.90(:\\d+)?$#',
    ],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
