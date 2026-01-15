<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class ImportLegacy extends Command
{
    protected $signature = 'legacy:import {table} {--path= : Path CSV file}';
    protected $description = 'Import legacy CSV exports into MySQL tables';

    public function handle(): int
    {
        $table = $this->argument('table');
        $path = $this->option('path') ?: storage_path("app/legacy/{$table}.csv");

        if (! File::exists($path)) {
            $this->error("CSV not found: {$path}");
            return Command::FAILURE;
        }

        $handle = fopen($path, 'r');
        if (! $handle) {
            $this->error('Failed to open CSV.');
            return Command::FAILURE;
        }

        $headers = fgetcsv($handle);
        if (! $headers) {
            $this->error('CSV header missing.');
            return Command::FAILURE;
        }

        $rows = [];
        while (($data = fgetcsv($handle)) !== false) {
            $rows[] = array_combine($headers, $data);
            if (count($rows) >= 500) {
                DB::table($table)->upsert($rows, ['id']);
                $rows = [];
            }
        }

        if ($rows) {
            DB::table($table)->upsert($rows, ['id']);
        }

        fclose($handle);

        $this->info("Import selesai untuk {$table}.");
        return Command::SUCCESS;
    }
}
