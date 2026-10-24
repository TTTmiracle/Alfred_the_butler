#!/usr/bin/env bash
# Jarvis'ni fonda ishga tushirish — systemd bo'lmagan joyda (konteyner).
# Haqiqiy VPS'da kerak emas: u yerda Jarvis servis sifatida o'zi yonadi.
LOG="$HOME/.openclaw/gateway.log"
# setup.sh'da tanlangan ism (IDENTITY.md dan), bo'lmasa — Jarvis
NAME=$(sed -n 's/^- \*\*Name:\*\* *//p' "$HOME/.openclaw/workspace/IDENTITY.md" 2>/dev/null | head -1)
NAME="${NAME:-Jarvis}"
pkill -f "openclaw gateway run" 2>/dev/null && sleep 2
nohup openclaw gateway run > "$LOG" 2>&1 &
echo "   $NAME ishga tushmoqda..."
for i in $(seq 1 45); do
  if openclaw gateway health >/dev/null 2>&1; then echo "   ✅ $NAME ishlayapti (log: $LOG)"; exit 0; fi
  sleep 2
done
echo "   ⚠️  $NAME 90 soniyada javob bermadi. Logga qarang: tail -50 $LOG"
exit 1
