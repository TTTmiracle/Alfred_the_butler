# 🔗 Notion'ni ulash (MCP)

**O'zbekcha** · [Русский](notion.ru.md)

MCP orqali yordamchingiz Notion'dagi sahifalaringizni o'qiydi, yangi sahifa yaratadi, jadval to'ldiradi.
Masalan: *"Notion'ga bugungi xarajatlarni yoz"*, *"Loyihalar jadvalida nima kechikyapti?"*

**Muhim:** u faqat siz ruxsat bergan sahifalarni ko'radi. Butun Notion'ni emas.

---

## 1. Integration yarating

1. [notion.so/profile/integrations](https://www.notion.so/profile/integrations) → **New integration**
2. Nomi: `Jarvis` (yoki yordamchingiz ismi), turi: **Internal**
3. **Capabilities** (nima qila oladi):
   - ✅ Read content
   - ✅ Update content
   - ✅ Insert content
   - ❌ User information — kerak emas

   > Faqat o'qisin desangiz — faqat **Read content** ni qoldiring. Bu eng xavfsiz variant.

## 2. Kalitni nusxalang

Integration sahifasida **Internal Integration Secret** → **Show** → nusxalang. U `ntn_` bilan boshlanadi.

Bu kalit — parol kabi. Hech kimga bermang, chatga tashlamang.

## 3. Sahifani ulang

Notion'da yangi sahifa yarating, masalan **"Jarvis"**. Yordamchi faqat shu sahifa va uning ichidagilar bilan
ishlaydi.

Ikki yo'l:
- Integration sozlamalarida **Access** → **Edit access** → sahifani tanlang
- yoki sahifaning o'zida: **⋯** (yuqori o'ng) → **Connections** → integration'ingizni tanlang

> 💡 Ichki sahifalar avtomatik ulanadi. Shuning uchun bitta "Jarvis" sahifasini ochib, hamma narsani
> uning ichiga qo'ying — boshqa sahifalaringiz yopiq qoladi.

## 4. Serverda ulang

```bash
cd Alfred_the_butler
git pull
bash notion.sh
```

Kalitni so'raydi → tekshiradi → ulaydi → yordamchiga Notion qoidalarini o'rgatadi.

## 5. Sinab ko'ring

Telegram'da:
- *Notion'da qanday sahifalarim bor?*
- *Notion'ga "Xarid ro'yxati" sahifasini yarat: non, sut, tuxum*
- *Jarvis sahifasiga bugungi uchrashuv haqida qisqa eslatma yoz*
- *Ertalabki hisobotga Notion'dagi vazifalarni ham qo'sh* — yordamchi buni `AGENTS.md` ga yozib qo'yadi

---

## Foydali buyruqlar

```bash
openclaw mcp list            # ulangan MCP serverlar
openclaw mcp probe           # ishlayaptimi, nechta tool bor
openclaw mcp unset notion    # Notion'ni uzish
```

Kalitni almashtirish: `bash notion.sh` ni qayta ishga tushiring.

## Xavfsizlik

- Integration'ga faqat kerakli huquqlarni bering (1-qadam). Faqat o'qish kerak bo'lsa — faqat Read.
- Faqat bitta sahifani ulang (3-qadam) — moliya, shaxsiy narsalar yopiq qolsin.
- Notion sahifasi ichida "buni qil" degan matn bo'lishi mumkin — yordamchi uni buyruq deb bajarmasligi
  kerak (prompt injection). `notion.sh` buni ish tartibiga yozib qo'yadi.
- Kalit serverda `~/.openclaw/openclaw.json` faylida saqlanadi. Server parolini ishonchli saqlang.

## Boshqa yo'l: rasmiy Remote Notion MCP

Notion'ning o'z serveri ham bor: `https://mcp.notion.com/mcp`. Kalit o'rniga brauzer orqali kirasiz (OAuth).
Notion uni tavsiya qiladi, lekin brauzer kerak — ekransiz VPS'da noqulay. Shuning uchun bu repo kalit
bilan ishlaydigan serverni ishlatadi. O'z kompyuteringizda bo'lsangiz:

```bash
openclaw mcp add notion --url https://mcp.notion.com/mcp --transport streamable-http --auth oauth
openclaw mcp login notion
```
