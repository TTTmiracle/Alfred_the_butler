#!/usr/bin/env bash
# Jarvis'ni fonda ishga tushirish — systemd bo'lmagan joyda (konteyner).
# Haqiqiy VPS'da kerak emas: u yerda Jarvis servis sifatida o'zi yonadi.
LOG="$HOME/.openclaw/gateway.log"
pkill -f "openclaw gateway run" 2>/dev/null && sleep 2
nohup openclaw gateway run > "$LOG" 2>&1 &
echo "   Jarvis ishga tushmoqda..."
for i in $(seq 1 45); do
  if openclaw gateway health >/dev/null 2>&1; then echo "   ✅ Jarvis ishlayapti (log: $LOG)"; exit 0; fi
  sleep 2
done
echo "   ⚠️  Jarvis 90 soniyada javob bermadi. Logga qarang: tail -50 $LOG"
exit 1
