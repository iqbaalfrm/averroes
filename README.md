# Averroes Monorepo

## Structure
- `mobile/` Flutter app
- `backend/` Laravel API + Filament admin
- `docs/` project notes

## Mobile (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

## Backend (Laravel + Filament)
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

Scheduler for news sync:
```bash
php artisan schedule:work
```

Legacy CSV import (optional):
```bash
php artisan legacy:import profiles --path=storage/app/legacy/profiles.csv
```

## Environment Setup
Root `.env.example` lists required keys.

### Mobile
Create `mobile/.env`:
```
API_BASE_URL=http://167.99.69.90/api
```

### Backend
Create `backend/.env` with MySQL + mail config. Seeded admin user:
- email: `admin@averroes.id`
- password: `Admin123!`
