#!/usr/bin/env bash
# Jarvis — o'rnatish / установка
# Ishlatish: bash setup.sh
set -euo pipefail
cd "$(dirname "$0")"
REPO="$(pwd)"

say()  { echo; echo "▶ $1"; }
fail() { echo; echo "❌ $1"; exit 1; }

echo "🤖 Jarvis o'rnatilmoqda"

# 1. Telegram ma'lumotlari
say "1/6  Telegram"
echo "   @BotFather'da yaratgan botingiz tokeni (masalan 123456789:AAH...):"
read -r -p "   BOT TOKEN: " BOT_TOKEN
[[ "$BOT_TOKEN" =~ ^[0-9]+:[A-Za-z0-9_-]+$ ]] || fail "Token noto'g'ri ko'rinishda. @BotFather'dan qayta nusxalang."
echo "   Sizning Telegram ID raqamingiz (faqat raqam). Bilmasangiz: @userinfobot ga /start yozing."
read -r -p "   TELEGRAM ID: " TG_ID
[[ "$TG_ID" =~ ^[0-9]+$ ]] || fail "ID faqat raqamlardan iborat bo'lishi kerak."

# 2. Tekshiruv
say "2/6  Server tekshiruvi"
bash "$REPO/check.sh" "$BOT_TOKEN" || fail "Tekshiruvda muammo chiqdi. ❌ larni tuzating va qayta ishga tushiring."

# 3. OpenClaw o'rnatish
say "3/6  OpenClaw o'rnatilmoqda (bir necha daqiqa)"
if ! command -v openclaw >/dev/null 2>&1; then
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash -s -- --no-onboard
  export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
  hash -r
fi
command -v openclaw >/dev/null 2>&1 || fail "openclaw topilmadi. Terminalni yopib-ochib, 'bash setup.sh' ni qayta ishga tushiring."
openclaw --version

# 4. Model va kalit
say "4/6  Model tanlash"
cat <<'EOF2'
   Qaysi AI'dan foydalanasiz?
   1) DeepSeek     — arzon, kartasi bilan to'lash oson
   2) Google Gemini
   3) OpenAI (ChatGPT)
   4) OpenRouter   — bitta kalit bilan ko'p model
   5) Anthropic (Claude)
   6) Ollama       — mahalliy model, shu kompyuterda (bepul, kuchli kompyuter kerak)
EOF2
read -r -p "   Raqam (1-6): " CHOICE
COMMON=(--non-interactive --accept-risk --flow quickstart --mode local --skip-channels --skip-ui --skip-search --install-daemon)
if [ "$CHOICE" = "6" ]; then
  curl -s -m 3 http://127.0.0.1:11434/api/version >/dev/null 2>&1 || fail "Ollama ishlamayapti. Avval Ollama'ni o'rnating va model yuklang: docs/mahalliy-ai.md"
  openclaw onboard "${COMMON[@]}" --auth-choice ollama
else
  read -r -s -p "   API kalit (ekranda ko'rinmaydi): " KEY; echo
  [ -n "$KEY" ] || fail "Kalit bo'sh."
  case "$CHOICE" in
    1) openclaw onboard "${COMMON[@]}" --auth-choice deepseek-api-key   --deepseek-api-key "$KEY" ;;
    2) openclaw onboard "${COMMON[@]}" --auth-choice gemini-api-key     --gemini-api-key "$KEY" ;;
    3) openclaw onboard "${COMMON[@]}" --auth-choice openai-api-key     --openai-api-key "$KEY" ;;
    4) openclaw onboard "${COMMON[@]}" --auth-choice openrouter-api-key --openrouter-api-key "$KEY" ;;
    5) openclaw onboard "${COMMON[@]}" --auth-choice apiKey             --anthropic-api-key "$KEY"
       # Opus emas, arzonroq Sonnet — kundalik yordamchiga yetarli
       openclaw models set anthropic/claude-sonnet-5-5 ;;
    *) fail "1 dan 6 gacha raqam kiriting." ;;
  esac
  unset KEY
fi
echo "   Tanlangan model: $(openclaw config get agents.defaults.model 2>/dev/null | tr -d '\n ')"

# 5. Jarvis fayllari va xavfsiz sozlamalar
say "5/6  Jarvis xarakteri va xavfsizlik"
WS="$HOME/.openclaw/workspace"
mkdir -p "$WS"
OLD="$HOME/.openclaw/eski-fayllar-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OLD"
for f in SOUL.md USER.md IDENTITY.md AGENTS.md vazifalar.md; do
  [ -f "$WS/$f" ] && cp "$WS/$f" "$OLD/"
  cp "$REPO/workspace/$f" "$WS/$f"
done
rm -f "$WS/BOOTSTRAP.md"

PATCH=$(mktemp --suffix=.json5)
sed "s/__BOT_TOKEN__/$BOT_TOKEN/; s/__TELEGRAM_ID__/$TG_ID/g" "$REPO/xavfsiz-sozlama.json5" > "$PATCH"
openclaw config patch --file "$PATCH"
rm -f "$PATCH"
openclaw gateway restart

# 6. Ertalabki hisobot
say "6/6  Ertalabki hisobot (har kuni 08:00, Toshkent vaqti)"
sleep 5
if ! openclaw cron list 2>/dev/null | grep -q "Ertalabki hisobot"; then
  openclaw cron add \
    --name ertalabki-hisobot \
    --display-name "Ertalabki hisobot" \
    --cron "0 8 * * *" --tz Asia/Tashkent \
    --message "Ertalabki hisobotni AGENTS.md dagi tartib bo'yicha tayyorla va yubor." \
    --announce --channel telegram --to "$TG_ID" >/dev/null
fi
openclaw cron list | grep -E "Ertalabki|Heartbeat" || true

echo
echo "✅ Tayyor!"
echo
echo "   Endi Telegram'da botingizga yozing:  Salom Jarvis"
echo
echo "   Foydali buyruqlar:"
echo "   openclaw status                 — hammasi ishlayaptimi"
echo "   openclaw logs --follow          — nima bo'layotganini jonli ko'rish"
echo "   openclaw cron run <ID>          — ertalabki hisobotni hozir sinash"
echo "   openclaw gateway usage-cost     — qancha pul ketdi"
echo "   openclaw security audit         — xavfsizlik tekshiruvi"
echo "   openclaw gateway stop           — Jarvis'ni o'chirish"
