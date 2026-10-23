# 🏠 Mahalliy AI — "Jarvis stansiya"

**O'zbekcha** · [Русский](mahalliy-ai.ru.md)

Instagram va YouTube'da ko'rgan "Jarvis + Mac Studio" — aynan shu: AI modeli internetdagi kompaniya
serverida emas, **sizning stolingizdagi qutida** ishlaydi.

## Nega bunga pul sarflashadi

| Afzallik | Izoh |
|---|---|
| 🔒 Ma'lumot chiqmaydi | hech narsa OpenAI/Google'ga ketmaydi. Klinika, bank, yurist mijozlari uchun — shart (15-dars) |
| ♾️ Cheksiz ishlatish | har so'rovga pul yo'q. Jarvis kun-u tun ishlasa ham hisob kelmaydi |
| 🌐 Internetsiz ishlaydi | model yuklangandan keyin |
| 🤖 Ko'p agent | bir qutida bir nechta Jarvis (har mijozga bittadan) |

| Kamchilik | Izoh |
|---|---|
| 💸 Boshlang'ich narx | $1 300 dan $10 000+ gacha |
| 🧠 Sifat | eng yaxshi mahalliy modellar ham eng yaxshi bulut modellardan (Claude, GPT) orqada |
| 🐢 Tezlik | bulutdan sekinroq |
| 🔧 Hammasi sizda | svet o'chsa, internet uzilsa — Jarvis ham o'chadi |

**Pul hisobi:** agar API'ga oyiga $50 ketayotgan bo'lsa, $2 700 lik quti o'zini ~4,5 yilda qoplaydi. Faqat pul
uchun — arzimaydi. Maxfiylik, cheksiz ishlatish yoki mijozning talabi uchun — arziydi.

---

## Asosiy qoida: xotira (RAM)

Model to'liq xotiraga sig'ishi kerak. **Model fayli + ~30% ≥ xotira** (15-dars).

Mac va AMD Ryzen AI Max'da protsessor va videokarta **bitta umumiy xotira**ni ishlatadi (unified memory) —
shuning uchun 128 GB li kichik quti katta modellarni ko'tara oladi. Oddiy kompyuterda esa videokarta
xotirasi (VRAM, odatda 8–24 GB) cheklaydi.

**Tezlik** ≈ xotira tezligi (GB/s) ÷ model hajmi (GB). Shuning uchun Mac Studio'ning tez xotirasi muhim.

**Agent uchun kamida ~9B model kerak.** Kichik modellar (2–4B) suhbatga yaraydi, lekin agent ishida —
buyruq ishlatish, fayl o'qish — tez-tez adashadi. Yaxshi natija 27B dan boshlanadi.

---

## Qurilmalar — oktyabr 2026

Narxlar — AQSh, taxminan. O'zbekistonda odatda qimmatroq.

### 🥉 Boshlash: o'zingizdagi kompyuter

| | Xotira | Qaysi model | Izoh |
|---|---|---|---|
| Noutbuk / kompyuter | 16–32 GB | `qwen3.5:9b`, `gemma4:e4b` | sinab ko'rish uchun. Jarvis faqat kompyuter yoqiq paytda ishlaydi |

### 🥈 Mac mini — kichikroq modellar uchun

| Model | Xotira | Narx | Qaysi model | Izoh |
|---|---|---|---|---|
| Mac mini **M6** | 32 GB | ~$1 300 | 9B–14B | jim, kam svet yeydi (~5–30 W) |
| Mac mini **M5 Pro** | 64 GB | ~$2 700 | `qwen3.5:27b`, `gemma4:26b` | **eng yaxshi narx/sifat**. 27B modellar ~10–20 token/s |

### 🥇 Mac Studio — "Jarvis stansiya"

| Model | Xotira | Narx | Qaysi model | Izoh |
|---|---|---|---|---|
| Mac Studio **M5 Max** | 64 GB | ~$3 500 | 27B–34B tezroq | xotira 614 GB/s — mini'dan 2 baravar tez |
| Mac Studio **M5 Max** | 128 GB | ~$5 100 | 70B, `qwen3.5:122b` (q4, ~81 GB) | katta modellar uchun |
| Mac Studio **M5 Ultra** | 96 GB | $5 499 dan | 70B tez | 1,2 TB/s |
| Mac Studio **M5 Ultra** | 256 GB | ~$9 500 | eng katta ochiq modellar | |
| Mac Studio **M5 Ultra** | 512 GB | hali e'lon qilinmagan | DeepSeek darajasidagi gigant modellar | oktyabr oxirida chiqishi kutilmoqda |

### Mac bo'lmagan variantlar

| Qurilma | Xotira | Narx | Izoh |
|---|---|---|---|
| **AMD Ryzen AI Max+ 395** mini-PC (GMKtec EVO-X2, Framework Desktop, Bosgame M5) | 128 GB | ~$3 300–3 650 | 128 GB uchun eng arzoni. Linux/Windows. Xotirasi Mac Studio'dan sekinroq (~256 GB/s) |
| **NVIDIA DGX Spark** | 64 GB | $4 999 | 23-oktyabrdan sotuvda. NVIDIA CUDA — AI dasturlari birinchi bo'lib shunga chiqadi |
| **NVIDIA DGX Spark** | 128 GB | $6 950 | ~200B gacha modellar (NVIDIA ma'lumoti) |

> 💡 **MoE modellar** (masalan, `gemma4:26b` — 26B dan faqat ~4B ishlaydi) katta model sifatini kichik model
> tezligida beradi. Lekin hammasi baribir xotiraga sig'ishi kerak (15-dars).

---

## Ikki xil qurilish

**A) Hammasi bitta qutida** — eng oddiy

```
Telegram ⇄ [ Mac Studio: OpenClaw + Ollama ]
```

**B) Bo'lingan** — ishonchliroq

```
Telegram ⇄ [ arzon VPS: OpenClaw ] ⇄ (Tailscale) ⇄ [ uydagi quti: Ollama ]
```

Jarvis VPS'da doim yoqiq turadi, og'ir ishni (model) uydagi quti bajaradi. Ular
[Tailscale](https://tailscale.com) — yopiq shaxsiy tarmoq orqali bog'lanadi; Ollama internetga ochilmaydi.

---

## O'rnatish (A variant, Mac yoki Linux)

**1. Ollama** — [ollama.com/download](https://ollama.com/download)

**2. Model yuklash** (xotirangizga qarab):

```bash
ollama pull qwen3.5:27b      # 64 GB uchun
# ollama pull qwen3.5:9b     # 16–32 GB uchun
```

**3. Kontekstni kattalashtirish** — agentga kamida 64 000 token kerak:

```bash
# Linux (systemd):
sudo systemctl edit ollama
#   [Service]
#   Environment="OLLAMA_CONTEXT_LENGTH=65536"
sudo systemctl restart ollama

# Mac: Ollama ilovasi sozlamalarida "Context length" ni 64k ga qo'ying
```

**4. Jarvis:**

```bash
git clone https://github.com/TTTmiracle/jarvis.git
cd jarvis
bash setup.sh        # "Qaysi AI" savolida → 6 (Ollama)
```

**5. Doim yoqiq turishi uchun:**
- Mac: *Sozlamalar → Energiya → "Displey o'chganda uyquga ketmasin"* yoqing
- **UPS** (uzluksiz quvvat manbai) — svet o'chganda Jarvis ham o'chmasin
- Simli internet (Wi-Fi emas)

⚠️ OpenClaw'da Ollama manzili **`/v1` siz** bo'lishi kerak: `http://127.0.0.1:11434`. `/v1` qo'shilsa,
agent buyruqlarni ishlata olmay qoladi (OpenClaw hujjatlari).

---

## Qachon nima tanlash

| Holat | Tanlov |
|---|---|
| Sinab ko'rmoqchiman | o'z kompyuterim + `qwen3.5:9b` |
| O'zim uchun doimiy Jarvis, maxfiylik muhim | Mac mini M5 Pro 64 GB |
| Mijozlar uchun bir nechta agent, katta modellar | Mac Studio M5 Max 128 GB |
| Arzonroq 128 GB, Linux bilan ishlay olaman | Ryzen AI Max+ 395 mini-PC |
| AI dasturlash, model o'qitish (16-dars) | NVIDIA DGX Spark |
| Faqat pulni tejash | quti olmang — arzon API (DeepSeek, Gemini) ishlating |
