# ❤️ Hartslag — mijn eerste iPhone-app

Een iOS-app die:

1. je **hartslag uitleest** uit Apple Health (met tijdstip van de meting),
2. die met één tik **deelt** via WhatsApp, Berichten, Mail, …
3. en waarmee je **vrienden toevoegt** en hun vraagt: *"Wat is jouw hartslag?"* —
   zij krijgen een berichtje met een link die hún app opent, en sturen met één
   tik hun hartslag terug.

Gemaakt als leerproject: het doel is *leren hoe je een iPhone-app maakt en op
je eigen telefoon zet*.

## 🚀 Aan de slag

Het complete Xcode-project zit in deze repo — instellingen, app-icoon, alles.

1. Haal deze repo binnen op je Mac (branch `claude/festive-cori-aqSEA`).
2. Open **`Hartslag.xcodeproj`**.
3. Kies je eigen team onder *Signing & Capabilities* en druk op ▶.

👉 De uitgebreide, rustige uitleg staat in **[STAPPENPLAN.md](STAPPENPLAN.md)**.

## 📂 De code

| Map / bestand | Taak |
|---|---|
| [`HartslagApp.swift`](Hartslag/HartslagApp.swift) | Startpunt; maakt de gedeelde helpers aan |
| [`Models/Friend.swift`](Hartslag/Models/Friend.swift) | Het vriend-model + de bewaarde vriendenlijst |
| [`Models/HeartRateRequest.swift`](Hartslag/Models/HeartRateRequest.swift) | De `hartslag://`-links maken en lezen |
| [`Services/HealthManager.swift`](Hartslag/Services/HealthManager.swift) | Al het contact met Apple Health |
| [`Views/ContentView.swift`](Hartslag/Views/ContentView.swift) | Het hoofdscherm |
| [`Views/HeartRateCard.swift`](Hartslag/Views/HeartRateCard.swift) | De rode kaart met je hartslag |
| [`Views/FriendRow.swift`](Hartslag/Views/FriendRow.swift) | Eén regel in de vriendenlijst |
| [`Views/RequestView.swift`](Hartslag/Views/RequestView.swift) | Het scherm bij een binnengekomen verzoek |
| [`Views/UIKitBridges.swift`](Hartslag/Views/UIKitBridges.swift) | Bruggen naar contactenkiezer en Berichten |

## 🛠️ Techniek & principes

- **Swift + SwiftUI**, **HealthKit**, **ContactsUI**, **MessageUI**
- Eén bron van waarheid: gedeelde `HealthManager`/`FriendsStore` via `environmentObject`
- Schermen bevatten geen Health-logica (scheiding van taken)
- Geen server of betaald account nodig: **de Berichten-app is de postbode**
- Donkere modus, Dynamic Type en VoiceOver werken mee dankzij systeem-bouwstenen

## 📋 Vereisten

- Mac met **Xcode 16 of nieuwer** (gratis)
- **iPhone** met iOS **17+** (HealthKit werkt niet in de simulator)
- Gratis **Apple ID**
