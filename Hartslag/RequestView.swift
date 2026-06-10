import SwiftUI

// Dit is het scherm dat JE VRIEND ziet zodra hij/zij jouw verzoek-link opent.
// Het vraagt: "<naam> vraagt je hartslag" en biedt een knop om die terug te sturen.
struct RequestView: View {

    let fromName: String                                  // van wie komt het verzoek?
    @StateObject private var health = HealthManager()     // eigen "tolk" naar Health
    @Environment(\.dismiss) private var dismiss           // om dit scherm te sluiten

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {

                Text("❤️")
                    .font(.system(size: 64))

                Text("\(fromName) vraagt:\n\u{201C}Wat is jouw hartslag?\u{201D}")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)

                if let bpm = health.latestHeartRate {
                    // Hartslag opgehaald: toon 'm en bied een knop om terug te sturen.
                    Text("\(Int(bpm)) bpm")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(.red)

                    ShareLink(item: "Mijn hartslag is \(Int(bpm)) bpm ❤️") {
                        Label("Stuur terug naar \(fromName)", systemImage: "paperplane.fill")
                            .font(.headline)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.blue, in: Capsule())
                    }
                } else {
                    // Nog niets opgehaald: knop om de eigen hartslag te lezen.
                    Button {
                        Task {
                            await health.requestAuthorization()
                            await health.fetchLatestHeartRate()
                        }
                    } label: {
                        Label("Haal mijn hartslag op", systemImage: "heart.fill")
                            .font(.headline)
                            .padding()
                            .background(.red.opacity(0.15), in: Capsule())
                    }
                }

                if let message = health.statusMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Sluiten") { dismiss() }
                }
            }
        }
        .task { await health.requestAuthorization() }
    }
}
