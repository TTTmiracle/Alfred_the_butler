# 🤖 Jarvis — shaxsiy AI yordamchingiz

**O'zbekcha** · [Русский](README.ru.md)

Telegram'da yashaydigan, o'z serveringizda ishlaydigan shaxsiy AI yordamchi. U:

- Telegram'da siz bilan gaplashadi (o'zbekcha yoki ruscha)
- vazifalaringizni yozib boradi va eslatadi
- har kuni ertalab 08:00 da o'zi hisobot yuboradi: ob-havo, vazifalar, kechagi ishlar
- serverda ishlarni bajaradi — lekin ruxsatsiz buyruqdan oldin Telegram'da sizdan so'raydi
- faqat sizga javob beradi — boshqalar yozsa, jim turadi

Ichida [OpenClaw](https://openclaw.ai) ishlaydi — 2026-yilning eng mashhur ochiq kodli AI agenti. Bu repo
uni Jarvis qilib, xavfsiz sozlab beradi.

---

## Nima kerak

| | Nima | Qayerdan |
|---|---|---|
| 1 | **Server** (VPS) — Linux, kamida 2 GB RAM | Contabo, HOSTIN.UZ, AIRNET va h.k. (~60 000 so'm/oy). Yoki o'z kompyuteringiz — [mahalliy variant](docs/mahalliy-ai.md) |
| 2 | **Telegram bot tokeni** | Telegram'da [@BotFather](https://t.me/BotFather) → `/newbot` |
| 3 | **Telegram ID raqamingiz** | [@userinfobot](https://t.me/userinfobot) ga `/start` yozing |
| 4 | **AI kalit** (API key) — quyidagilardan bittasi | pastda ⬇️ |

### Qaysi AI'ni tanlash

| Provayder | Izoh |
|---|---|
| **DeepSeek** | arzon, boshlash uchun yaxshi |
| **Google Gemini** | bepul limiti bor — sinab ko'rish uchun |
| **OpenAI** (ChatGPT) | kuchli, o'rtacha narx |
| **OpenRouter** | bitta kalit bilan ko'p model, bepul modellari ham bor |
| **Anthropic** (Claude) | eng aqllilaridan, qimmatroq. Setup arzonroq Sonnet'ni qo'yadi |
| **Ollama** | mahalliy model — bepul, ma'lumot chiqmaydi, lekin kuchli kompyuter kerak → [batafsil](docs/mahalliy-ai.md) |

⚠️ Kalit ochganda **xarajat limiti** qo'ying (masalan, oyiga $5). Bepul modellar agent ishida zaifroq va ba'zilari
ma'lumotingizdan o'qish uchun foydalanadi — mijoz ishi uchun pullik kalit oling.

---

## O'rnatish

Serverga kiring:

```bash
ssh root@SERVER_IP
```

Repo'ni yuklab, o'rnatishni boshlang:

```bash
git clone https://github.com/TTTmiracle/Alfred_the_butler.git
cd Alfred_the_butler
bash setup.sh
```

`setup.sh` so'raydi: bot tokeni → Telegram ID → yordamchi ismi (Jarvis, Alfred...) → qaysi AI → API kalit. Qolganini o'zi qiladi:

1. Serverni tekshiradi (`check.sh`) — Telegram'ga ulanish bormi, internet, RAM
2. OpenClaw'ni o'rnatadi
3. Siz tanlagan AI'ni ulaydi
4. Jarvis xarakterini (o'zbekcha) va xavfsiz sozlamalarni qo'yadi
5. Ertalabki hisobotni yoqadi (08:00, Toshkent)

Tugagach — Telegram'da botingizga yozing: **Salom Jarvis** 👋

### Server yo'qmi? Kompyuteringizda "server" yarating

VPS — bu shunchaki boshqa kompyuter. Sinab ko'rish uchun uni o'z kompyuteringiz ichida yaratish mumkin
(konteyner). Kerak: Linux yoki Mac'da [Podman](https://podman.io) yoki Docker.

```bash
git clone https://github.com/TTTmiracle/Alfred_the_butler.git
bash Alfred_the_butler/konteyner.sh
```

Siz `root@jarvis-server` ichidasiz — xuddi VPS kabi. Keyin yuqoridagi buyruqlar (`git clone`, `bash setup.sh`).
Farqi bitta: kompyuteringiz o'chsa, Jarvis ham o'chadi. Qayta yoqish: `bash konteyner.sh`, ichida `bash start.sh`.

---

## Jarvis'ni o'zingizga moslash

Jarvis kim ekanini oddiy matn fayllari belgilaydi. Ular serverda: `~/.openclaw/workspace/`

| Fayl | Nima | Misol |
|---|---|---|
| `SOUL.md` | xarakteri, gapirish uslubi, chegaralari | "Sen restoranim administratorining yordamchisisan" |
| `USER.md` | siz haqingizda | ismingiz, kasbingiz, qanday javob yoqishi |
| `AGENTS.md` | ish tartibi, ertalabki hisobot tarkibi | "Hisobotga kechagi buyurtmalarni qo'sh" |
| `vazifalar.md` | vazifalar ro'yxati | Jarvis o'zi yuritadi |

Tahrirlash:

```bash
nano ~/.openclaw/workspace/SOUL.md
```

Yoki shunchaki Telegram'da ayting: *"Bundan keyin javoblarni ruscha yoz, USER.md ga yozib qo'y"*.

**G'oyalar:**
- 🍔 Restoran: "Har kuni 23:00 da kunlik savdo xulosasini yubor"
- 👩‍🏫 O'qituvchi: "Ertalab bugungi darslar rejasini eslat"
- 💼 Frilanser: "Har dushanba haftalik vazifalar ro'yxatini tuz"

---

## Notion'ni ulash (ixtiyoriy)

Yordamchingiz Notion sahifalaringizni o'qiydi va yozadi (MCP orqali, 13-dars):

```bash
bash notion.sh
```

Avval Notion'da integration yarating — 5 daqiqa: [docs/notion.md](docs/notion.md)

---

## Foydali buyruqlar

```bash
openclaw status                  # hammasi ishlayaptimi
openclaw logs --follow           # Jarvis nima qilayotganini jonli ko'rish
openclaw cron list               # rejalashtirilgan ishlar
openclaw cron run <ID>           # ertalabki hisobotni hozir sinash
openclaw gateway usage-cost      # qancha pul ketdi (DeepSeek uchun 0 ko'rsatishi mumkin — aniq summa: platform.deepseek.com)
openclaw security audit          # xavfsizlik tekshiruvi
openclaw gateway restart         # qayta ishga tushirish
openclaw gateway stop            # o'chirish
```

Telegram'da `/new` — yangi suhbat. SOUL.md, USER.md, AGENTS.md ni o'zgartirgandan keyin yozing: Jarvis fayllarni
qaytadan o'qiydi. Suhbat uzaygan sari har xabar qimmatlashadi — vaqti-vaqti bilan `/new` pulni ham tejaydi.

Yangi vaqtli ish qo'shish (masalan, har juma 18:00 da):

```bash
openclaw cron add --name juma --cron "0 18 * * 5" --tz Asia/Tashkent \
  --message "Haftalik xulosa tayyorla" --announce --channel telegram --to <TELEGRAM_ID>
```

---

## Xavfsizlik — nima qo'yilgan

| Sozlama | Nima qiladi |
|---|---|
| `dmPolicy: allowlist` | faqat sizning ID'ingizga javob beradi |
| `groupPolicy: disabled` | guruhlarda ishlamaydi |
| `exec: allowlist + ask` | serverda ruxsat berilmagan buyruqdan oldin Telegram'da tugma bilan so'raydi |
| `fs.workspaceOnly` | fayllar bilan faqat o'z papkasida ishlaydi |
| `elevated: off` | root huquqlari yo'q |
| `heartbeat: 2h, 08–23` | o'zi tekshirib turish — 2 soatda bir, kechasi emas (pulni tejaydi) |

Hammasi `xavfsiz-sozlama.json5` da, izohlari bilan.

**Esda tuting:**
- Jarvis'ga parol, karta raqami bermang
- Xat yoki sayt ichida "buni qil" degan yashirin buyruq bo'lishi mumkin (prompt injection). Jarvis ularni
  bajarmasligi kerak — lekin 100% kafolat yo'q. Shuning uchun muhim ishlar faqat sizning tasdig'ingiz bilan
- Bitta bot tokenini ikki joyda ishlatmang

---

## Muammolar

| Belgisi | Sabab va yechim |
|---|---|
| Bot umuman javob bermaydi | `openclaw status` → gateway ishlayaptimi. `openclaw logs --follow` → xatoni o'qing |
| Javob daqiqalab kechikadi | server Telegram'ga sekin ulanmoqda. `bash check.sh <TOKEN>` → ❌ va 👉 ga qarang |
| `check.sh`: "IPv4 orqali Telegram'ga ulanib bo'lmadi" | hosting Telegram'ni to'syapti. `mtr -rwc 20 -T -P 443 149.154.167.220` natijasini hosting support'ga yuboring yoki boshqa region/provayder |
| "Eski webhook qolgan" | `curl "https://api.telegram.org/bot<TOKEN>/deleteWebhook?drop_pending_updates=true"` |
| Bot birovga javob bermaydi | to'g'ri — faqat sizga javob beradi. Boshqa odam qo'shish: `openclaw config set channels.telegram.allowFrom '[ID1, ID2]'` |
| `openclaw: command not found` | terminalni yopib-oching yoki `source ~/.bashrc` |
| SOUL.md ni o'zgartirdim, lekin bot eskicha gapiradi | Telegram'da `/new` — yangi suhbat fayllarni qaytadan o'qiydi |
| `check.sh`: "IPv6 orqali ulanib bo'lmadi" | `echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf` (root bo'lmasangiz — `sudo tee -a`), keyin `bash check.sh` → ✅ |
| Notion'da "hech qanday sahifa yo'q" | sahifani integration'ga ulamagansiz: sahifada ⋯ → Connections → integration'ingiz |

Qo'shimcha: `openclaw doctor --fix` — ko'p muammolarni o'zi tuzatadi.

---

## O'chirish

```bash
openclaw uninstall
```

---

📚 [Mahalliy AI va "Jarvis stansiya" (Mac Studio, Mac mini, DGX Spark)](docs/mahalliy-ai.md) · [Notion ulash](docs/notion.md)

---

*Bu repo **AI Coding & Automation** kursining amaliy darsi uchun tayyorlangan.*
