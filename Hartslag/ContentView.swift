import SwiftUI

// Dit is het scherm dat de gebruiker ziet.
// In SwiftUI beschrijf je gewoon "wat er op het scherm staat",
// en de telefoon tekent het voor je.
struct ContentView: View {

    // We maken één exemplaar van onze "tolk" naar Health (zie HealthManager.swift).
    // @StateObject zorgt dat 'ie blijft leven zolang het scherm bestaat.
    @StateObject private var health = HealthManager()

    var body: some View {
        VStack(spacing: 32) {

            Text("❤️ Mijn hartslag")
                .font(.largeTitle)
                .bold()

            // Hebben we al een hartslag? Dan tonen we 'm groot, plus een deel-knop.
            if let bpm = health.latestHeartRate {

                Text("\(Int(bpm)) bpm")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(.red)

                // ShareLink opent het bekende iOS-deelmenu.
                // Daar kies je WhatsApp / Berichten / Mail / ... en verstuur je
                // de tekst naar een vriend. Geen server of account nodig!
                ShareLink(item: "Mijn hartslag is op dit moment \(Int(bpm)) bpm ❤️") {
                    Label("Stuur naar een vriend", systemImage: "paperplane.fill")
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.blue, in: Capsule())
                }

            } else {
                // Nog niets opgehaald: een rustig "leeg" beeld.
                Text("—")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(.secondary)
                Text("Nog geen meting opgehaald")
                    .foregroundStyle(.secondary)
            }

            // Knop om (opnieuw) de laatste hartslag op te halen.
            Button {
                // Een knop-actie mag niet "wachten", maar ophalen duurt heel even.
                // Daarom stoppen we het in een Task { } zodat het netjes async gebeurt.
                Task {
                    await health.requestAuthorization()
                    await health.fetchLatestHeartRate()
                }
            } label: {
                Label("Hartslag ophalen", systemImage: "heart.fill")
                    .font(.headline)
                    .padding()
                    .background(.red.opacity(0.15), in: Capsule())
            }

            // Als er iets misging (of een tip is), tonen we dat hier.
            if let message = health.statusMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        // .task draait automatisch zodra het scherm verschijnt:
        // we vragen meteen netjes om toestemming.
        .task {
            await health.requestAuthorization()
        }
    }
}

// Dit blokje is alleen voor de "preview" in Xcode (live voorbeeld naast je code).
// Het draait niet mee in de echte app.
#Preview {
    ContentView()
}
