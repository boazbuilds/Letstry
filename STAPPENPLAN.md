# 📱 Stappenplan: je eigen hartslag-app op je iPhone

Dit is een rustig, stap-voor-stap plan om je eerste iPhone-app op je eigen
telefoon te zetten. Je kunt na elke stap stoppen en later verder gaan.

> **Wat de app doet:** je hartslag uitlezen uit Apple Health, die delen, en
> vrienden een verzoek sturen: *"Wat is jouw hartslag?"*

**Goed nieuws:** het complete Xcode-project zit al in deze map — inclusief alle
instellingen (HealthKit, privacy-teksten, de `hartslag://`-link) en een app-icoon.
Je hoeft dus **niets** meer te kopiëren, plakken of aan te vinken. Openen, je
Apple ID kiezen en op ▶ drukken.

---

## Wat je nodig hebt

- ✅ Een **Mac** + een **iPhone** + een kabel
- ✅ Een **gratis Apple ID** (geen betaald developer-account van €99/jaar nodig)
- ⏱️ Ongeveer **1 uur** de eerste keer (Xcode downloaden duurt het langst)

> 💡 Met een gratis Apple ID blijft de app **7 dagen** werken. Daarna sluit je de
> iPhone weer even aan en druk je opnieuw op ▶ — weer 7 dagen.

---

## Stap 1 — Xcode installeren

1. Open op je Mac de **App Store**, zoek **Xcode** en klik **Installeer**
   (grote download, ☕-moment).
2. Open Xcode één keer; accepteer de licentie en laat de extra onderdelen
   ("iOS platform") installeren.

---

## Stap 2 — Het project op je Mac krijgen

Het project staat op GitHub in de branch **`claude/festive-cori-aqSEA`**.
Twee manieren (kies wat je fijn vindt):

**Makkelijkst — ZIP downloaden:**
1. Ga in je browser naar je repository `boazbuilds/Letstry`.
2. Klik linksboven op het branch-menu (waar `main` staat) en kies
   **`claude/festive-cori-aqSEA`**.
3. Klik op de groene knop **Code** → **Download ZIP**, en pak de ZIP uit
   (bijv. in je Documenten-map).

**Of via de Terminal:**
```bash
git clone -b claude/festive-cori-aqSEA https://github.com/boazbuilds/Letstry.git
```

---

## Stap 3 — Openen en ondertekenen (signing)

Apple wil weten wie een app maakt. Dat regel je één keer:

1. Dubbelklik op **`Hartslag.xcodeproj`** — het project opent in Xcode.
2. Klik links op het blauwe project-icoon **Hartslag** (bovenste regel in de zijbalk).
3. Kies onder **TARGETS** → **Hartslag** → tabblad **Signing & Capabilities**.
4. Bij **Team**: klik het menu open → **Add an Account…** → log in met je
   **Apple ID** → kies daarna je naam met **(Personal Team)** erachter.
5. Zie je een rode melding dat de **Bundle Identifier** al in gebruik is?
   Verander 'm dan in iets unieks, bijv. `nl.boazstruik.hartslag2`.

> ℹ️ Je ziet daar ook het **HealthKit**-blokje al staan — dat heb ik alvast
> voor je geconfigureerd, net als de privacy-teksten en de `hartslag://`-link.

---

## Stap 4 — Op je iPhone zetten

> ⚠️ HealthKit en Berichten werken **niet** in de simulator — je hebt je echte
> iPhone nodig. Precies de bedoeling 😄.

1. Sluit je iPhone met de kabel aan. Tik op je iPhone op **Vertrouw** en voer
   je toegangscode in.
2. **Ontwikkelaarsmodus aanzetten** (eenmalig, verplicht sinds iOS 16):
   - iPhone: **Instellingen → Privacy en beveiliging → Ontwikkelaarsmodus**
     → zet **aan** → telefoon herstart → bevestig na de herstart.
   - Zie je die optie nog niet? Hij verschijnt zodra je iPhone één keer aan
     Xcode gekoppeld is geweest (doe eerst stap 3 + 4.1).
3. Kies bovenin Xcode, naast "Hartslag", **jouw iPhone** als apparaat
   (niet een simulator).
4. Druk op **▶ (Run)** of Cmd+R.
5. Foutmelding "Untrusted Developer"? Normaal bij de eerste keer:
   - iPhone: **Instellingen → Algemeen → VPN en apparaatbeheer** → tik op je
     Apple ID → **Vertrouw**. Druk daarna nog eens op ▶.

De app staat nu op je telefoon! 🎉

---

## Stap 5 — Eerste test: je eigen hartslag

1. De app vraagt toegang tot je hartslag → zet **aan** / **Sta toe**.
2. Tik op **Ophalen** in de rode kaart (of trek de lijst omlaag om te verversen).

   **Geen meting gevonden?** Hartslag-data komt meestal van een Apple Watch.
   Geen Watch? Voeg een test-meting toe:
   - **Health**-app → **Blader** → **Hart** → **Hartslag** → rechtsboven
     **Voeg gegevens toe** → typ bv. `72` → **Voeg toe**.
   - Terug in de app: nog eens **Ophalen**.

3. Tik op **Delen** → kies WhatsApp/Berichten → verstuur. De app deelt ook
   het tijdstip van de meting mee — wel zo eerlijk.

---

## Stap 6 — Vrienden en het hartslag-verzoek

**Hoe het werkt:** je tikt op een vriend → de Berichten-app opent met een
kant-en-klaar berichtje + een speciale `hartslag://`-link. Je vriend (met de
app op zíjn telefoon) opent die link → ziet *"Boaz vraagt: wat is jouw
hartslag?"* → zijn hartslag wordt opgehaald → één tik om terug te sturen.
Geen server nodig: **de Berichten-app is de postbode.**

1. Vul onderin **jouw naam** in (die ziet je vriend bij het verzoek).
2. Tik rechtsboven op **+** en kies een vriend uit je contacten.
3. Tik op de vriend in de lijst → Berichten opent → verstuur.

**De ontvang-kant zelf testen (zonder tweede telefoon):**
open **Safari** op je iPhone en typ in de adresbalk:

```
hartslag://verzoek?van=Test
```

→ Jouw app springt open met het verzoek-scherm. Zo zie je precies wat je
vriend straks ziet. 🎉

**Je vriend de app geven:** sluit zijn/haar iPhone aan je Mac, kies die in
Xcode en druk op ▶ (ook 7 dagen geldig). Op afstand delen kan later via
TestFlight, maar daar is een betaald account voor nodig.

---

## Problemen oplossen

| Probleem | Oplossing |
|---|---|
| Rode signing-fout | Stap 3: Team gekozen? Bundle Identifier uniek gemaakt? |
| "Untrusted Developer" | Instellingen → Algemeen → VPN en apparaatbeheer → Vertrouw |
| Ontwikkelaarsmodus-melding | Stap 4.2 — aanzetten en herstarten |
| Geen hartslag gevonden | Voeg handmatig een meting toe (stap 5) |
| Link niet blauw/tikbaar in Berichten | Bekende iOS-beperking bij eigen links; je vriend kan de app ook gewoon zelf openen |
| Project opent niet | Update Xcode via de App Store; lukt het dan nog niet, zie Plan B hieronder |

<details>
<summary><strong>Plan B: het project zelf aanmaken (alleen als het meegeleverde project niet opent)</strong></summary>

1. Xcode → File → New → Project → iOS → App. Naam `Hartslag`, Interface
   **SwiftUI**, taal **Swift**.
2. Sleep alle `.swift`-bestanden uit de mappen `Hartslag/`, `Hartslag/Models/`,
   `Hartslag/Services/` en `Hartslag/Views/` van deze repo het project in
   (vink "Copy items if needed" aan). Verwijder de door Xcode aangemaakte
   `ContentView.swift`.
3. Target → **Signing & Capabilities** → **+ Capability** → **HealthKit**.
4. Target → **Info** → voeg toe:
   - `Privacy - Health Share Usage Description` → "Deze app leest je hartslag
     zodat je die kunt bekijken en naar een vriend kunt sturen."
   - Onder **URL Types**: klik **+** en zet bij **URL Schemes**: `hartslag`.
5. Verder vanaf stap 4 hierboven.

</details>

---

## Hoe de code in elkaar zit (voor de nieuwsgierigen)

De code is opgedeeld zoals professionele apps dat doen — elk bestand heeft
één duidelijke taak:

| Map / bestand | Taak |
|---|---|
| `HartslagApp.swift` | Startpunt; maakt de gedeelde helpers aan |
| `Models/Friend.swift` | Wat een vriend "is" + de bewaarde vriendenlijst |
| `Models/HeartRateRequest.swift` | De `hartslag://`-links maken en lezen |
| `Services/HealthManager.swift` | Al het contact met Apple Health |
| `Views/ContentView.swift` | Het hoofdscherm (bewust dun gehouden) |
| `Views/HeartRateCard.swift` | De rode kaart met je hartslag |
| `Views/FriendRow.swift` | Eén regel in de vriendenlijst |
| `Views/RequestView.swift` | Het scherm dat je vriend ziet bij een verzoek |
| `Views/UIKitBridges.swift` | Bruggen naar de contactenkiezer en Berichten |

Een paar principes die erin verwerkt zitten (en die je overal terugziet in
goede apps):

- **Eén bron van waarheid** — `HealthManager` en `FriendsStore` bestaan precies
  één keer en worden met alle schermen gedeeld via `environmentObject`.
- **Scheiding van taken** — schermen weten níets van HealthKit; dat doet de
  service. Daardoor blijft elk bestand klein en leesbaar.
- **Eerlijke informatie** — bij elke meting tonen we het tijdstip; een hartslag
  van gisteren als "nu" presenteren zou misleidend zijn.
- **Apple's eigen bouwstenen** — SF Symbols-iconen, systeemlijsten, het
  deelmenu: daardoor werkt donkere modus, grote tekst en VoiceOver vanzelf.
- **Kleine details** — het hartje klopt, nieuwe cijfers rollen om, en je voelt
  een tikje (haptiek) bij een nieuwe meting.

## Ideeën voor daarna

- 📈 Een grafiekje met je hartslag van vandaag (`Swift Charts`)
- ⌚ Een Apple Watch-versie die live je hartslag streamt
- ☁️ De "echte" versie met pushmeldingen (CloudKit + betaald account)
- ✈️ De app naar vrienden sturen via TestFlight
