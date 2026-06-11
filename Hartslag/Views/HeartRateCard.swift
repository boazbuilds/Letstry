import SwiftUI

// De grote rode kaart bovenaan met je eigen hartslag.
struct HeartRateCard: View {

    @EnvironmentObject private var health: HealthManager

    var body: some View {
        VStack(spacing: 14) {

            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .symbolEffect(.pulse)        // het hartje klopt rustig door
                .accessibilityHidden(true)   // puur decoratie, dus VoiceOver slaat 'm over

            if let reading = health.reading {
                Text("\(reading.bpm)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())   // cijfers "rollen" mooi om
                Text("slagen per minuut · gemeten om \(reading.date.formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
            } else {
                Text("––")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                Text("Nog geen meting opgehaald")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
            }

            HStack(spacing: 12) {
                Button {
                    Task { await health.fetchLatestHeartRate() }
                } label: {
                    Label("Ophalen", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.white, in: Capsule())
                        .foregroundStyle(.red)
                }
                .disabled(health.isLoading)

                // De deel-knop verschijnt pas zodra er iets te delen valt.
                if let text = health.shareText {
                    ShareLink(item: text) {
                        Label("Delen", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.25), in: Capsule())
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.top, 4)

            if health.isLoading {
                ProgressView()
                    .tint(.white)
            }

            if let message = health.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(maxWidth: .infinity)
        // Nodig omdat de kaart in een List staat: zonder dit zou een tik op de
        // rij ALLE knoppen tegelijk indrukken. Zo is elke knop apart tikbaar.
        .buttonStyle(.borderless)
        .padding(24)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.00, green: 0.36, blue: 0.43),
                    Color(red: 0.78, green: 0.06, blue: 0.27),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        // Veranderingen (nieuw getal, knop erbij) gaan met een vloeiende animatie.
        .animation(.default, value: health.reading)
        // Klein tril-momentje als er een nieuwe meting binnenkomt.
        .sensoryFeedback(.success, trigger: health.reading)
    }
}

#Preview {
    HeartRateCard()
        .environmentObject(HealthManager())
        .padding()
}
