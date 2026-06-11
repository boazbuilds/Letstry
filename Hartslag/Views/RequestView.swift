import SwiftUI

// Het scherm dat je ziet als een vriend JOU om je hartslag vraagt —
// dus als je op een "hartslag://"-link tikt.
struct RequestView: View {

    let request: HeartRateRequest

    @EnvironmentObject private var health: HealthManager
    @Environment(\.dismiss) private var dismiss   // om dit scherm te sluiten

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Image(systemName: "heart.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.red)
                    .symbolEffect(.pulse)
                    .accessibilityHidden(true)

                Text("\(request.fromName) vraagt:")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("\u{201C}Wat is jouw hartslag?\u{201D}")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                if health.isLoading {
                    ProgressView("Hartslag ophalen…")
                } else if let reading = health.reading {
                    Text("\(reading.bpm) bpm")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(.red)
                    Text("gemeten om \(reading.date.formatted(date: .omitted, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    if let text = health.shareText {
                        ShareLink(item: text) {
                            Label("Stuur terug naar \(request.fromName)", systemImage: "paperplane.fill")
                                .font(.headline)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(.red, in: Capsule())
                        }
                    }
                } else {
                    // Het automatisch ophalen lukte niet? Dan kun je het hier nog eens proberen.
                    Button {
                        Task { await health.fetchLatestHeartRate() }
                    } label: {
                        Label("Haal mijn hartslag op", systemImage: "heart.fill")
                            .font(.headline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(.red.opacity(0.15), in: Capsule())
                    }
                }

                if let message = health.errorMessage {
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
            // Zodra dit scherm verschijnt: toestemming checken en meteen ophalen,
            // zodat je vriend zo min mogelijk hoeft te tikken.
            .task {
                await health.requestAuthorization()
                await health.fetchLatestHeartRate()
            }
        }
    }
}

#Preview {
    RequestView(request: HeartRateRequest(fromName: "Sanne"))
        .environmentObject(HealthManager())
}
