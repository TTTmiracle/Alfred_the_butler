#!/usr/bin/env bash
# Jarvis — server tekshiruvi / проверка сервера
# Ishlatish: bash check.sh            (umumiy tekshiruv)
#            bash check.sh <BOT_TOKEN> (bot tokenini ham tekshiradi)

TOKEN="${1:-}"
OK=0; BAD=0
SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo "   # root'da (konteyner, VPS) sudo kerak emas va o'rnatilmagan bo'lishi mumkin
ok()   { echo "  ✅ $1"; OK=$((OK+1)); }
bad()  { echo "  ❌ $1"; [ -n "$2" ] && echo "     👉 $2"; BAD=$((BAD+1)); }
warn() { echo "  ⚠️  $1"; [ -n "$2" ] && echo "     👉 $2"; }

# curl orqali ulanish vaqti: dns / ulanish / tls / jami
timing() { curl "$1" -s -o /dev/null -m 15 -w "%{time_namelookup} %{time_connect} %{time_appconnect} %{time_total} %{http_code}" "$2" 2>/dev/null; }

echo "🔎 Jarvis — server tekshiruvi"
echo

echo "1) Kompyuter"
RAM_MB=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo 2>/dev/null || echo 0)
DISK_GB=$(df -Pk "$HOME" | awk 'NR==2 {print int($4/1024/1024)}')
if [ "$RAM_MB" -ge 1800 ]; then ok "RAM: ${RAM_MB} MB"; else bad "RAM: ${RAM_MB} MB — kam" "Kamida 2 GB RAM'li server oling"; fi
if [ "$DISK_GB" -ge 5 ]; then ok "Bo'sh disk: ${DISK_GB} GB"; else bad "Bo'sh disk: ${DISK_GB} GB — kam" "Kamida 5 GB bo'sh joy kerak"; fi
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR=$(node -p 'process.versions.node.split(".")[0]')
  if [ "$NODE_MAJOR" -ge 24 ]; then ok "Node: $(node --version)"
  else warn "Node $(node --version) eski (OpenClaw'ga 24+ kerak)" "setup.sh yangisini o'zi o'rnatadi"; fi
else
  warn "Node o'rnatilmagan" "setup.sh uni o'zi o'rnatadi"
fi
echo

echo "2) Internet"
# Bitta sayt sekin bo'lsa ham "internet yo'q" demaslik uchun: 3 ta manzil, faqat sarlavha (HEAD), birinchi javob yetarli
NET_T=""
for url in https://www.gstatic.com/generate_204 https://1.1.1.1/cdn-cgi/trace https://api.telegram.org; do
  read -r T CODE <<< "$(curl -4 -sI -o /dev/null -m 8 -w "%{time_total} %{http_code}" "$url" 2>/dev/null)"
  if [ -n "$CODE" ] && [ "$CODE" != "000" ]; then NET_T="$T"; break; fi
done
if [ -n "$NET_T" ]; then ok "Internet bor (${NET_T}s)"; else bad "Internet yo'q" "Server tarmog'ini tekshiring"; fi
echo

echo "3) Telegram"
if getent hosts api.telegram.org >/dev/null; then
  IP=$(getent ahostsv4 api.telegram.org | awk 'NR==1 {print $1}')
  case "$IP" in
    149.154.*|91.108.*) ok "DNS: api.telegram.org → $IP" ;;
    *) bad "DNS noto'g'ri manzil berdi: $IP" "/etc/hosts ni tekshiring yoki DNS'ni 1.1.1.1 ga almashtiring" ;;
  esac
else
  bad "DNS api.telegram.org ni topa olmadi" "DNS'ni 1.1.1.1 yoki 8.8.8.8 ga almashtiring"
fi

read -r D C S T CODE <<< "$(timing -4 https://api.telegram.org)"
if [ "$CODE" != "000" ]; then
  ok "IPv4 orqali ulanish: ${T}s"
else
  bad "IPv4 orqali Telegram'ga ulanib bo'lmadi (ulanish: ${C}s)" \
      "Tarmoq Telegram'ni to'syapti. 'mtr -rwc 20 -T -P 443 149.154.167.220' natijasini hosting support'ga yuboring yoki boshqa region/provayder tanlang"
fi

if [ -n "$(ip -6 route show default 2>/dev/null)" ]; then
  read -r D C S T CODE <<< "$(timing -6 https://api.telegram.org)"
  if [ "$CODE" != "000" ]; then
    ok "IPv6 orqali ulanish: ${T}s"
  elif grep -q '^precedence ::ffff:0:0/96' /etc/gai.conf 2>/dev/null; then
    ok "IPv6 ishlamaydi, lekin IPv4 afzal qilingan (/etc/gai.conf) — kechikish bo'lmaydi"
  else
    warn "IPv6 orqali ulanib bo'lmadi — bot javoblari daqiqalab kechikishi mumkin" \
         "Tuzatish: echo 'precedence ::ffff:0:0/96 100' | ${SUDO}tee -a /etc/gai.conf"
  fi
fi

if [ -n "$TOKEN" ]; then
  R=$(curl -4 -s -m 15 "https://api.telegram.org/bot${TOKEN}/getMe")
  if echo "$R" | grep -q '"ok":true'; then
    ok "Bot tokeni ishlayapti: @$(echo "$R" | sed -n 's/.*"username":"\([^"]*\)".*/\1/p')"
  else
    bad "Bot tokeni ishlamadi" "@BotFather'dan tokenni qayta nusxalang (bo'sh joysiz)"
  fi
  W=$(curl -4 -s -m 15 "https://api.telegram.org/bot${TOKEN}/getWebhookInfo")
  if echo "$W" | grep -q '"url":"[^"]'; then
    warn "Botda eski webhook qolgan — OpenClaw xabarlarni ololmaydi" \
         "curl \"https://api.telegram.org/bot<TOKEN>/deleteWebhook?drop_pending_updates=true\""
  fi
fi
echo

echo "4) AI provayderlar (qaysi biri ochiq)"
for host in api.openai.com api.anthropic.com api.deepseek.com generativelanguage.googleapis.com openrouter.ai; do
  read -r D C S T CODE <<< "$(timing -4 "https://$host")"
  if [ "$CODE" != "000" ]; then ok "$host (${T}s)"; else warn "$host — ulanib bo'lmadi" "Shu provayderni tanlamang yoki tarmoqni tekshiring"; fi
done
if curl -s -m 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
  ok "Ollama shu kompyuterda ishlayapti (mahalliy model)"
fi
echo

if [ "$BAD" -eq 0 ]; then
  echo "🎉 Hammasi joyida ($OK ✅). Davom eting: bash setup.sh"
else
  echo "⛔ $BAD ta muammo bor. Avval ❌ larni tuzating, keyin qayta ishga tushiring."
  exit 1
fi
