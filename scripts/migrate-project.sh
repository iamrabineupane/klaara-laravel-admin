#!/usr/bin/env bash
# scripts/migrate-project.sh PROJECT_DIR [--apply]
# For a Laravel project that used encore/laravel-admin: rewrites `Encore\Admin` to `Klaara\Admin`
# in app/, config/, routes/, resources/, database/, tests/ and bootstrap/.
# Without --apply it only lists the files that would change. Review the result with `git diff`.
set -u
DIR="${1:-}"
APPLY="${2:-}"
if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then echo "usage: $0 PROJECT_DIR [--apply]"; exit 1; fi
cd "$DIR" || exit 1
paths=()
for p in app config routes resources database tests bootstrap; do
  if [ -d "$p" ]; then paths+=("$p"); fi
done
if [ "${#paths[@]}" -eq 0 ]; then echo "no app/ config/ routes/ ... directory found in $DIR"; exit 1; fi
mapfile -d '' files < <(grep -rIlZE 'Encore(\\{1,2})Admin' "${paths[@]}" 2>/dev/null)
echo "${#files[@]} file(s) mention Encore\\Admin:"
if [ "${#files[@]}" -gt 0 ]; then printf '  %s\n' "${files[@]}"; fi
if [ "$APPLY" != "--apply" ]; then echo "Dry run. Run again with --apply to rewrite them."; exit 0; fi
if [ "${#files[@]}" -gt 0 ]; then sed -i -E 's/Encore(\\{1,2})Admin/Klaara\1Admin/g' "${files[@]}"; fi
echo "Rewritten. Now run: composer remove encore/laravel-admin && composer require klaara/laravel-admin && php artisan config:clear"
