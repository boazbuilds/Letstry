# ❤️ Hartslag — mijn eerste iPhone-app

Een hele simpele iOS-app die:

1. je **hartslag uitleest** uit Apple Health, en
2. die met één tik **naar een vriend stuurt** (via WhatsApp, Berichten, Mail, …).

Gemaakt als oefenproject: het doel is *leren hoe je een iPhone-app maakt en op je
eigen telefoon zet* — niet zozeer wat de app allemaal kan.

## 🚀 Aan de slag

👉 Volg het **[STAPPENPLAN.md](STAPPENPLAN.md)** — een rustige, Nederlandse gids die je
stap voor stap door alles heen loodst (Xcode installeren, project maken, op je iPhone zetten).

## 📂 De code

Alle code staat in de map [`Hartslag/`](Hartslag/):

| Bestand | Wat het doet |
|---|---|
| [`HartslagApp.swift`](Hartslag/HartslagApp.swift) | Het startpunt van de app. |
| [`ContentView.swift`](Hartslag/ContentView.swift) | Het scherm: tekst, knoppen en de deel-knop. |
| [`HealthManager.swift`](Hartslag/HealthManager.swift) | Praat met Apple Health: toestemming + hartslag ophalen. |

## 🛠️ Techniek

- **Swift** + **SwiftUI** (Apple's moderne manier om apps te bouwen)
- **HealthKit** om de hartslag te lezen
- De iOS-**deelfunctie** (`ShareLink`) om naar een vriend te sturen — geen server of account nodig

## 📋 Vereisten

- Een Mac met **Xcode** (gratis)
- Een **iPhone** (HealthKit werkt niet in de simulator)
- Een **gratis Apple ID** (geen betaald developer-account nodig)
- iOS **17** of nieuwer
