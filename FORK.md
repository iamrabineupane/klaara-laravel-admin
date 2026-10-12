# About this fork

This package is a maintained fork of [z-song/laravel-admin](https://github.com/z-song/laravel-admin) (`encore/laravel-admin`), released under the MIT license.
The features, views, config key (`admin`), route names, artisan commands (`admin:*`) and database tables are unchanged. **The PHP namespace was renamed from `Encore\Admin` to `Klaara\Admin`.**

What changed compared with upstream 1.8.x:

- package `klaara/laravel-admin`, namespace `Klaara\Admin`;
- supports Laravel 10, 11 and 12 on PHP 8.1 and newer;
- `doctrine/dbal` is no longer required (`admin:make` reads the columns with `Schema::getColumns()`; Doctrine is only used as a fallback on Laravel versions that have no such method);
- `symfony/dom-crawler` constraint widened to `^6.0|^7.0`;
- implicitly nullable parameters (`Closure $x = null`) are now explicitly nullable (PHP 8.4+);
- `Request::get()` calls replaced by `Request::input()`.

Use it in an existing project:

    composer remove encore/laravel-admin
    composer require klaara/laravel-admin
    scripts/migrate-project.sh /path/to/your/project           # dry run: lists the files that mention Encore\Admin
    scripts/migrate-project.sh /path/to/your/project --apply   # rewrites Encore\Admin -> Klaara\Admin
    php artisan config:clear

The package declares `conflict: encore/laravel-admin` (never install both). Extensions that hard-code `Encore\Admin` (laravel-admin-ext/*) must be ported the same way before they work with this fork.
The original license and copyright notice are kept in `LICENSE`.
