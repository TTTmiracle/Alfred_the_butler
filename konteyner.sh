#!/usr/bin/env bash
# Kompyuteringiz ichida "server" yaratadi — VPS o'rniga, ko'rsatish va sinash uchun.
# Ishlatish:  bash konteyner.sh            (yaratadi yoki borini ochadi)
#             bash konteyner.sh --yangi    (o'chirib, noldan yaratadi)
set -euo pipefail
NAME=jarvis-server
ENGINE=$(command -v podman || command -v docker || true)
[ -n "$ENGINE" ] || { echo "❌ Podman yoki Docker kerak: https://podman.io"; exit 1; }

if [ "${1:-}" = "--yangi" ]; then "$ENGINE" rm -f "$NAME" >/dev/null 2>&1 || true; fi

if ! "$ENGINE" container exists "$NAME" 2>/dev/null && ! "$ENGINE" inspect "$NAME" >/dev/null 2>&1; then
  echo "▶ Yangi server yaratilmoqda: $NAME (Debian Linux)"
  "$ENGINE" run -d --name "$NAME" --hostname "$NAME" docker.io/library/debian:bookworm sleep infinity >/dev/null
  "$ENGINE" exec "$NAME" bash -c "apt-get update -qq && apt-get install -y -qq curl git ca-certificates procps nano iproute2 >/dev/null"
  echo "✅ Server tayyor"
else
  "$ENGINE" start "$NAME" >/dev/null
fi
echo "▶ Serverga kirilmoqda (chiqish: exit)"
exec "$ENGINE" exec -it -w /root "$NAME" bash
