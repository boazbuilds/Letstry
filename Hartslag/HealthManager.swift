import Foundation
import HealthKit

// Deze klasse regelt ALLE communicatie met Apple Health.
// Je kunt 'm zien als de "tolk" tussen jouw app en de Health-app.
//
// @MainActor zorgt dat alle updates netjes op het hoofd-scherm gebeuren.
// ObservableObject zorgt dat de app automatisch het scherm bijwerkt
// zodra hier iets verandert (bijvoorbeeld een nieuwe hartslag).
@MainActor
final class HealthManager: ObservableObject {

    // De "doorgang" naar alle gezondheidsgegevens op de telefoon.
    private let healthStore = HKHealthStore()

    // Welk soort gegeven willen we? In dit geval: hartslag.
    private let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

    // @Published betekent: "let op, als dit verandert, ververs het scherm".
    @Published var latestHeartRate: Double?      // de laatst gemeten hartslag (bpm)
    @Published var statusMessage: String?        // een tekstje voor de gebruiker (bv. een foutje)

    /// Vraagt de gebruiker eenmalig om toestemming om de hartslag te mógen lezen.
    /// (Apple verplicht dit: een app mag nooit zomaar gezondheidsdata inzien.)
    func requestAuthorization() async {
        // Sommige apparaten (zoals een iPad) hebben geen Health. Even checken.
        guard HKHealthStore.isHealthDataAvailable() else {
            statusMessage = "Health is niet beschikbaar op dit apparaat."
            return
        }

        do {
            // toShare = [] -> we willen niets wegschrijven, alleen lezen.
            // read = [heartRateType] -> we vragen leesrechten voor hartslag.
            try await healthStore.requestAuthorization(toShare: [], read: [heartRateType])
        } catch {
            statusMessage = "Toestemming mislukt: \(error.localizedDescription)"
        }
    }

    /// Haalt de meest recente hartslag-meting uit Health op.
    func fetchLatestHeartRate() async {
        // We beschrijven onze "zoekopdracht":
        // - alleen hartslag-metingen
        // - gesorteerd op tijd, nieuwste eerst
        // - we willen er maar 1 (de allerlaatste)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: heartRateType)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
            limit: 1
        )

        do {
            let samples = try await descriptor.result(for: healthStore)

            // Geen enkele meting gevonden? Laat dat netjes weten.
            guard let sample = samples.first else {
                statusMessage = "Nog geen hartslag gevonden in Health. Voeg er handmatig eentje toe in de Health-app, of draag een Apple Watch."
                return
            }

            // Een hartslag wordt opgeslagen als "tellingen per minuut" (bpm).
            let bpmUnit = HKUnit.count().unitDivided(by: .minute())
            latestHeartRate = sample.quantity.doubleValue(for: bpmUnit)
            statusMessage = nil   // alles gelukt, geen foutmelding tonen
        } catch {
            statusMessage = "Ophalen mislukt: \(error.localizedDescription)"
        }
    }
}
