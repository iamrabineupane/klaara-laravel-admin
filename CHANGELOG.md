# Changelog

## Unreleased (fork)

- Package renamed to `klaara/laravel-admin`, namespace renamed `Encore\Admin` -> `Klaara\Admin` (see FORK.md and scripts/migrate-project.sh).
- Laravel 10 / 11 / 12 support, PHP >= 8.1.
- `doctrine/dbal` is optional; `admin:make` uses `Schema::getColumns()`.
- PHP 8.4+: explicit nullable parameter types.
- `Request::get()` replaced by `Request::input()`.
