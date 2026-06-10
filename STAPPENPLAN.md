# 📱 Stappenplan: je eigen hartslag-app op je iPhone

Dit is een rustig, stap-voor-stap plan om je allereerste iPhone-app te maken en
op je eigen telefoon te zetten. Neem gerust de tijd; je kunt na elke stap stoppen
en later verder gaan.

> **Wat de app doet:** je hartslag uitlezen uit Apple Health en die met één tik
> naar een vriend sturen (via WhatsApp, Berichten, Mail — wat je maar wilt).

---

## Wat je nodig hebt

- ✅ Een **Mac** (die heb je)
- ✅ Een **iPhone** + een kabel om 'm aan je Mac te koppelen
- ✅ Een **gratis Apple ID** (heb je waarschijnlijk al; anders gratis aan te maken)
- ⏱️ Ongeveer **1 tot 1,5 uur** de eerste keer (Xcode downloaden duurt het langst)

> 💡 **Belangrijk:** je hebt geen betaald Apple Developer-account (€99/jaar) nodig!
> Met een gratis Apple ID mag je je eigen apps op je eigen iPhone zetten. De app
> blijft dan 7 dagen werken; daarna zet je 'm met één klik opnieuw "erop".

---

## Stap 1 — Xcode installeren

Xcode is het gratis programma van Apple waarmee je apps maakt.

1. Open op je Mac de **App Store**.
2. Zoek op **Xcode**.
3. Klik op **Installeer** (of het wolkje ☁️). Het is een grote download (meerdere GB),
   dus dit kan even duren — koffietijd ☕.
4. Open Xcode als het klaar is. Accepteer de licentie; mogelijk installeert hij nog
   wat extra onderdelen. Laat dat gewoon afmaken.

---

## Stap 2 — Een nieuw project maken

1. Open Xcode → klik op **Create New Project…** (of menu *File → New → Project…*).
2. Kies bovenin **iOS**, selecteer dan **App** en klik **Next**.
3. Vul in:
   - **Product Name:** `Hartslag`  ← *(precies zo typen, dan past de code straks 1-op-1)*
   - **Team:** laat even staan (regelen we in stap 5)
   - **Organization Identifier:** `com.jouwnaam` (verzin iets, bv. `com.boaz`)
   - **Interface:** **SwiftUI**
   - **Language:** **Swift**
   - Vinkjes voor *Tests* / *Core Data* mag je **uit** laten.
4. Klik **Next**, kies een map om het project te bewaren, en klik **Create**.

🎉 Je hebt nu een (lege) app! Links in de zijbalk zie je o.a. de bestanden
`HartslagApp.swift` en `ContentView.swift`.

---

## Stap 3 — De code erin zetten

Je vindt de complete code in dit project, in de map **`Hartslag/`**. Er zijn 3 bestandjes.
We zorgen dat jouw Xcode-project precies dezelfde inhoud krijgt.

**3a. Vervang `HartslagApp.swift`**
- Klik links op `HartslagApp.swift`.
- Selecteer alles (Cmd+A) en verwijder het.
- Kopieer de inhoud van [`Hartslag/HartslagApp.swift`](Hartslag/HartslagApp.swift) hierheen.

**3b. Vervang `ContentView.swift`**
- Klik links op `ContentView.swift`, wis de inhoud (Cmd+A, delete).
- Kopieer de inhoud van [`Hartslag/ContentView.swift`](Hartslag/ContentView.swift) hierheen.

**3c. Voeg een nieuw bestand toe: `HealthManager.swift`**
- Rechtsklik in de zijbalk op de map met je code → **New File from Template…**
  (of menu *File → New → File…*).
- Kies **Swift File** → **Next** → noem het **`HealthManager`** → **Create**.
- Wis de inhoud en plak de inhoud van [`Hartslag/HealthManager.swift`](Hartslag/HealthManager.swift).

> 💡 Zie je rode foutmeldingen? Geen paniek — meestal verdwijnen die zodra alle 3 de
> bestanden de juiste inhoud hebben. Pas in stap 4 zetten we HealthKit "aan".

---

## Stap 4 — HealthKit aanzetten (toestemming + capability)

Een app mag niet zomaar bij je gezondheidsgegevens. Dit moeten we expliciet aanzetten.

**4a. De HealthKit-capability toevoegen**
1. Klik links bovenin op het blauwe project-icoon (bovenste regel, "Hartslag").
2. Selecteer in het midden onder **TARGETS** je app **Hartslag**.
3. Open het tabblad **Signing & Capabilities**.
4. Klik op **+ Capability** (linksboven in dat tabblad).
5. Zoek en dubbelklik op **HealthKit**. Klaar — er staat nu een HealthKit-blokje.

**4b. Uitleg-tekst toevoegen (verplicht door Apple)**
Apple eist dat je uitlegt *waarom* je de hartslag wilt lezen. Die tekst ziet de
gebruiker in de toestemmings-popup.

1. Blijf bij je target en open het tabblad **Info**.
2. Beweeg je muis over een regel, klik op het **+** dat verschijnt.
3. Begin te typen: **`Privacy - Health Share Usage Description`** en kies die.
4. Zet als waarde bijvoorbeeld:
   > `Deze app leest je hartslag zodat je die kunt bekijken en naar een vriend kunt sturen.`

> ℹ️ De "technische" naam hiervan is `NSHealthShareUsageDescription`. We lezen alleen
> (we schrijven niets weg), dus dit is de enige die je nodig hebt.

---

## Stap 5 — Ondertekenen met je gratis Apple ID (signing)

Apple wil weten *wie* de app maakt. Dat heet "signing" en is met een gratis account zo gepiept.

1. Ga weer naar **Signing & Capabilities**.
2. Vink **Automatically manage signing** aan.
3. Bij **Team**: klik op het menu → **Add an Account…** → log in met je **Apple ID**.
4. Kies daarna je naam (er staat dan "(Personal Team)") bij **Team**.
5. Krijg je een rode melding dat de **Bundle Identifier** al bestaat? Maak 'm dan uniek,
   bv. `com.boaz.hartslag123`. (Hij moet wereldwijd uniek zijn.)

---

## Stap 6 — De app op je iPhone zetten

> ⚠️ **Let op:** HealthKit werkt **niet** in de iPhone-simulator op je Mac.
> Je hebt dus écht je eigen iPhone nodig. Dat is precies wat we willen 😄.

1. Verbind je iPhone met een kabel aan je Mac.
2. Op je iPhone verschijnt **"Vertrouw deze computer?"** → tik **Vertrouw** en voer je toegangscode in.
3. Bovenin Xcode, naast de naam "Hartslag", staat een keuzemenu voor het apparaat.
   Klik erop en kies **jouw iPhone** (niet een simulator).
4. Druk op de **▶ (Run)**-knop linksboven (of Cmd+R).
5. **Eerste keer**, foutmelding over een "untrusted developer"? Dat is normaal:
   - Pak je iPhone → **Instellingen → Algemeen → VPN en apparaatbeheer**.
   - Tik op jouw ontwikkelaar (je Apple ID) → **Vertrouw**.
   - Ga terug naar Xcode en druk nog een keer op **▶**.

Je app opent nu op je iPhone! 🎉

---

## Stap 7 — Testen en naar een vriend sturen

1. De app vraagt om toegang tot je hartslag → tik **Sta toe** / zet hartslag aan.
2. Tik op **"Hartslag ophalen"**.

   **Geen hartslag te zien?** Hartslag-data komt meestal van een Apple Watch.
   Heb je die niet, voeg dan handmatig een meting toe om te testen:
   - Open de **Health**-app → tabblad **Blader** → **Hart** → **Hartslag**
     → rechtsboven **Voeg gegevens toe** → typ bv. `72` → **Voeg toe**.
   - Ga terug naar jouw app en tik nog eens op **"Hartslag ophalen"**.

3. Tik op **"Stuur naar een vriend"** → kies bv. **WhatsApp** of **Berichten**
   → kies je vriend → verstuur. 🚀

**Gefeliciteerd — je hebt je eerste eigen iPhone-app gemaakt én gebruikt!**

---

## Goed om te weten

- 🔁 **7-dagen-regel:** met een gratis account verloopt de app na 7 dagen. Hij staat
  er dan nog wel, maar opent niet meer. Sluit je iPhone weer aan, druk op **▶**, en
  je bent weer 7 dagen verder. (Met een betaald account van €99/jaar is dat een jaar.)
- 🧪 **Simulator vs. echte telefoon:** voor Health-dingen heb je altijd je echte iPhone nodig.
- ❓ **Vastgelopen?** Schrijf op bij wélke stap en wat er precies op je scherm staat
  (een foto/screenshot helpt enorm), dan loodsen we je er samen doorheen.

---

## Hoe de app in elkaar zit (voor de nieuwsgierigen)

De app bestaat uit kleine, overzichtelijke bestanden:

| Bestand | Wat het doet |
|---|---|
| `HartslagApp.swift` | Het startpunt. Zegt: "begin hier, en toon het hoofdscherm." |
| `ContentView.swift` | Het hoofdscherm: jouw naam, je hartslag en je vriendenlijst. |
| `HealthManager.swift` | De "tolk" naar Apple Health: vraagt toestemming en haalt de hartslag op. |
| `Friends.swift` | Onthoudt je vrienden (naam + nummer) op de telefoon. |
| `UIKitBruggen.swift` | De contactkiezer en de Berichten-app aansturen. |
| `RequestView.swift` | Het scherm dat je vriend ziet als hij jouw verzoek opent. |

De code staat vol met Nederlandse uitleg-regels (de groene tekst achter `//`),
zodat je per regel kunt zien wat er gebeurt.

---

## 🧑‍🤝‍🧑 Uitbreiding: vrienden toevoegen + hartslag-verzoek

Heb je de basis-app werkend? Top! Nu breiden we 'm uit zodat je **vrienden kunt
toevoegen** en hun een verzoek *"Wat is je hartslag?"* kunt sturen.

> **Hoe het werkt (de "Messages-truc"):** je kiest een vriend uit je contacten en
> tikt erop. De Berichten-app opent met een kant-en-klaar berichtje + een speciale
> link. Je vriend (die de app óók heeft) opent die link, ziet jouw verzoek, en stuurt
> zijn hartslag terug. **Geen server nodig — gratis!**

### A. De nieuwe code toevoegen

1. **Vervang** de inhoud van `ContentView.swift` door de nieuwe versie uit
   [`Hartslag/ContentView.swift`](Hartslag/ContentView.swift).
2. Voeg **3 nieuwe bestanden** toe (rechtsklik in de zijbalk → *New File from Template…*
   → **Swift File**) en plak telkens de inhoud uit deze repo:
   - **`Friends.swift`** → [`Hartslag/Friends.swift`](Hartslag/Friends.swift)
   - **`UIKitBruggen.swift`** → [`Hartslag/UIKitBruggen.swift`](Hartslag/UIKitBruggen.swift)
   - **`RequestView.swift`** → [`Hartslag/RequestView.swift`](Hartslag/RequestView.swift)

> 💡 De onderdelen *Contacts* en *Berichten* worden vanzelf gekoppeld zodra je ze
> `import`-eert. Daar hoef je niets voor aan te zetten.

### B. De "hartslag://"-link registreren

Zodat je iPhone weet dat een `hartslag://`-link jóuw app moet openen:

1. Klik op het blauwe project-icoon → kies onder **TARGETS** je app → tabblad **Info**.
2. Scroll omlaag naar **URL Types** en klik op **+**.
3. Vul in:
   - **Identifier:** `com.boaz.hartslag` (mag je zelf verzinnen)
   - **URL Schemes:** `hartslag`  ← *dit veld is het belangrijkst!*

### C. (Optioneel) Contacten-uitleg

De contactkiezer vraagt meestal geen toestemming. Vraagt je app er tóch om? Voeg dan in
**Info** de sleutel **`Privacy - Contacts Usage Description`** toe, bv.:
"Om een vriend te kiezen om je hartslag mee te delen."

### D. Uitproberen

1. Druk weer op **▶ (Run)** om de nieuwe versie op je iPhone te zetten.
2. Vul bovenin **jouw naam** in.
3. Tik rechtsboven op **+** en kies een vriend uit je contacten.
4. Tik op die vriend in de lijst → de Berichten-app opent met het verzoek → verstuur.

> ⚠️ **Berichten sturen werkt alleen op een echte iPhone** (niet in de simulator).

### E. De ontvang-kant testen (in je eentje!)

Je vriend heeft de app ook nodig. Wil je het alvast zelf testen? Open op dezelfde
telefoon **Safari** en typ in de adresbalk:

```
hartslag://verzoek?van=Test
```

→ Je app springt open met het scherm **"Test vraagt je hartslag"**, waar je 'm kunt
ophalen en terugsturen. 🎉

### Eerlijk over de grenzen hiervan

- 👬 **Je vriend heeft de app óók nodig** (zijn hartslag staat in *zíjn* Health). Met een
  gratis account zet je de app op zijn telefoon door zijn iPhone even aan jouw Mac te
  koppelen en op ▶ te drukken (werkt dan 7 dagen). Makkelijk delen op afstand? Dan kom je
  uit bij een betaald account + **TestFlight** — een mooi vervolgproject.
- 🔗 **De link is niet altijd "tikbaar"** in Berichten (Apple maakt alleen bekende links
  blauw). Soms moet je vriend de app dus zelf even openen. Voor een oefen-app is dat prima.
