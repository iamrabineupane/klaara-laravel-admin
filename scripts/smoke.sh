#!/usr/bin/env bash
# scripts/smoke.sh [BASE_URL] - log in to laravel-admin (admin/admin) and request the main admin pages.
# Exit code 0 = every page answered 200 and none redirected back to the login page.
BASE="${1:-http://127.0.0.1:8765}"
JAR="$(mktemp)"
trap 'rm -f "$JAR"' EXIT
fail=0

check () {
  local name="$1" url="$2" allow_login="${3:-no}" out code final
  out="$(curl -s -o /dev/null -w '%{http_code} %{url_effective}' -b "$JAR" -c "$JAR" -L "$url")"
  code="${out%% *}"
  final="${out#* }"
  if [ "$code" != "200" ]; then echo "FAIL $name (status $code)"; fail=1; return; fi
  if [ "$allow_login" = "no" ] && [[ "$final" == *"/auth/login"* ]]; then echo "FAIL $name (redirected to login)"; fail=1; return; fi
  echo "PASS $name"
}

check "login page" "$BASE/admin/auth/login" yes
token="$(curl -s -b "$JAR" -c "$JAR" "$BASE/admin/auth/login" | grep -o 'name="_token" value="[^"]*"' | head -1 | sed 's/.*value="//; s/"$//')"
if [ -z "$token" ]; then echo "FAIL csrf token not found on the login page"; exit 1; fi
code="$(curl -s -o /dev/null -w '%{http_code}' -b "$JAR" -c "$JAR" -X POST "$BASE/admin/auth/login" --data-urlencode "_token=$token" --data-urlencode "username=admin" --data-urlencode "password=admin")"
case "$code" in
  302|200) echo "PASS login post ($code)" ;;
  *) echo "FAIL login post ($code)"; fail=1 ;;
esac
check "dashboard" "$BASE/admin"
for p in auth/users auth/roles auth/permissions auth/menu auth/logs auth/setting; do
  check "$p" "$BASE/admin/$p"
done
exit $fail
