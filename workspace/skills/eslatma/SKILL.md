---
name: eslatma
description: "Eslatma va jadval: bir martalik (--at) yoki takroriy (--cron / --every) cron ishi, Telegram'ga yetkazish. Kalit so'zlar: eslatib qo'y, eslat, har kuni, har hafta, jadval, reminder, cron."
---

# Eslatma va jadval (openclaw cron)

Eslatmani faqat `openclaw cron` qiladi. Faylga yozib qo'yish — eslatma emas: fayl o'zi xabar yubormaydi.

## 1. Vaqtni aniqla

Voqea vaqti va eslatma vaqti — boshqa-boshqa narsa:

- "Ertaga 10:00 da qo'ng'iroq qilishim kerak, eslatib qo'y" — 10:00 voqea vaqti. Eslatma: 1 soat oldin → 09:00.
- "Ertaga 10:00 da qo'ng'iroq, 30 daqiqa oldin eslat" — eslatma: 09:30.
- "Soat 10:00 da eslat" — eslatma vaqti aniq aytilgan → 10:00.
- Javobda ikkalasini ham ayt: "Qo'ng'iroq — 10:00, eslatma — 09:00".
- "Ertaga", "dushanba" kabi so'zlarni aniq sanaga aylantir (Toshkent vaqti).
- Sana yoki vaqt noaniq bo'lsa — avval so'ra, taxmin qilma.

## 2. Bir martalik eslatma

```
openclaw cron add --at "2026-10-25T14:00:00" --tz Asia/Tashkent \
  --name "eslatma-uchrashuv" --display-name "Uchrashuv (14:00)" \
  --message "Egaga qisqa eslatma yoz: 1 soatdan keyin (15:00) uchrashuv bor." \
  --agent main --announce --channel telegram --to __TELEGRAM_ID__ --delete-after-run
```

`--delete-after-run` — ish bajarilgach o'zi o'chadi.

## 3. Takroriy ish

```
openclaw cron add --cron "0 9 * * 1" --tz Asia/Tashkent \
  --name "haftalik-reja" --display-name "Haftalik reja (dushanba 09:00)" \
  --message "Egaga shu haftaning vazifalar ro'yxatini qisqa qilib yubor." \
  --agent main --announce --channel telegram --to __TELEGRAM_ID__
```

- Oraliq bilan: `--every 6h`. Har ishga tushish — pullik so'rov: ega aniq so'ramasa, 1 soatdan tez-tez qo'yma.
- Takroriy ishga `--delete-after-run` qo'yma.
- "Ertalabki hisobot" allaqachon bor — uni qayta yaratma.

## 4. Tekshir — keyin ayt

1. `openclaw cron list` — yangi ish ro'yxatda bormi, `Next` vaqti to'g'rimi.
   Vaqt UTC'da chiqadi: `09:00Z` = Toshkent 14:00 (+5).
2. Faqat shundan keyin yoz: "✅ Eslatma qo'yildi: 25-oktabr, 14:00".
3. Xato chiqsa yoki ish ro'yxatda bo'lmasa — ochiq ayt. Ro'yxatda ish yo'q bo'lsa, hech qachon "eslatib qo'yaman" dema.
4. Vazifani `vazifalar.md` ga ham qo'sh.

## 5. Boshqarish

- Ko'rish: `openclaw cron list`, `openclaw cron show <ID>`
- O'chirish: `openclaw cron rm <ID>` — avval egadan so'ra.
- O'zgartirish: `openclaw cron edit <ID> --<maydon> <qiymat>`
- Hozir sinash: `openclaw cron run <ID>`

## Mumkin emas

- `--command`, `--webhook`, `--stream-command`, `--trigger-script`, `--on-exit` ishlatma.
  Ular jadval bo'yicha serverda buyruq ishlatadi yoki ma'lumotni tashqariga yuboradi.
  Ega so'rasa — xavfini tushuntir va buyruqni o'zi terishini ayt.
- `--to` — faqat egangning ID'si: __TELEGRAM_ID__. Boshqa chatga yuborma.
