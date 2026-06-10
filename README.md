# ❤️ Hartslag — mijn eerste iPhone-app

Een simpele iOS-app die:

1. je **hartslag uitleest** uit Apple Health,
2. die met één tik **deelt** (via WhatsApp, Berichten, Mail, …), en
3. waarmee je **vrienden kunt toevoegen** en hun een verzoek *"Wat is je hartslag?"* stuurt.

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
| [`ContentView.swift`](Hartslag/ContentView.swift) | Het hoofdscherm: naam, hartslag en vriendenlijst. |
| [`HealthManager.swift`](Hartslag/HealthManager.swift) | Praat met Apple Health: toestemming + hartslag ophalen. |
| [`Friends.swift`](Hartslag/Friends.swift) | Onthoudt je vrienden (naam + nummer) op de telefoon. |
| [`UIKitBruggen.swift`](Hartslag/UIKitBruggen.swift) | Contactkiezer + de Berichten-app aansturen. |
| [`RequestView.swift`](Hartslag/RequestView.swift) | Het scherm dat je vriend ziet bij een verzoek. |

## 🛠️ Techniek

- **Swift** + **SwiftUI** (Apple's moderne manier om apps te bouwen)
- **HealthKit** om de hartslag te lezen
- **Contacts** om een vriend te kiezen, en **MessageUI** om het verzoek te sturen
- Een **diep-link** (`hartslag://`) zodat je vriend het verzoek-scherm opent
- Alles **zonder server of betaald account** — de Berichten-app is de "postbode"

## 📋 Vereisten

- Een Mac met **Xcode** (gratis)
- Een **iPhone** (HealthKit werkt niet in de simulator)
- Een **gratis Apple ID** (geen betaald developer-account nodig)
- iOS **17** of nieuwer
