import Foundation
import HealthKit

// Eén meting: hoeveel slagen per minuut, en wannéér gemeten.
// (Het tijdstip tonen is wel zo eerlijk: de laatste meting kan oud zijn.)
struct HeartRateReading: Equatable {
    let bpm: Int
    let date: Date
}

// Deze klasse regelt ALLE communicatie met Apple Health — de "tolk"
// tussen jouw app en de Health-app. De rest van de app hoeft daardoor
// niets van HealthKit te weten (scheiding van taken).
//
// @MainActor: alle updates gebeuren netjes op de hoofd-draad van het scherm.
// ObservableObject: schermen verversen automatisch als hier iets verandert.
@MainActor
final class HealthManager: ObservableObject {

    // private(set): de hele app mag dit LEZEN, maar alleen deze klasse
    // mag het VERANDEREN. Zo kan niets per ongeluk de boel verstoren.
    @Published private(set) var reading: HeartRateReading?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    // De "doorgang" naar alle gezondheidsgegevens op de telefoon.
    private let healthStore = HKHealthStore()
    private let heartRateType = HKQuantityType(.heartRate)

    /// Vraagt eenmalig toestemming om de hartslag te mógen lezen.
    /// (Apple verplicht dit: een app mag nooit zomaar gezondheidsdata inzien.)
    func requestAuthorization() async {
        // Sommige apparaten (zoals een iPad) hebben geen Health. Even checken.
        guard HKHealthStore.isHealthDataAvailable() else {
            errorMessage = "Health is niet beschikbaar op dit apparaat."
            return
        }

        do {
            // toShare: [] -> we schrijven niets weg, we lezen alleen.
            try await healthStore.requestAuthorization(toShare: [], read: [heartRateType])
        } catch {
            errorMessage = "Toestemming vragen mislukte: \(error.localizedDescription)"
        }
    }

    /// Haalt de meest recente hartslag-meting uit Health op.
    func fetchLatestHeartRate() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }   // wat er ook gebeurt: laad-status weer uit

        // Onze "zoekopdracht": alleen hartslag, nieuwste eerst, maximaal 1.
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: heartRateType)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
            limit: 1
        )

        do {
            guard let sample = try await descriptor.result(for: healthStore).first else {
                errorMessage = "Geen hartslag gevonden in Health. Tip: voeg er in de Health-app handmatig één toe, of draag een Apple Watch."
                return
            }

            // Een hartslag is opgeslagen als "tellingen per minuut" (bpm).
            let bpmUnit = HKUnit.count().unitDivided(by: .minute())
            reading = HeartRateReading(
                bpm: Int(sample.quantity.doubleValue(for: bpmUnit).rounded()),
                date: sample.startDate
            )
        } catch {
            errorMessage = "Ophalen mislukte: \(error.localizedDescription)"
        }
    }

    /// De tekst die we delen of terugsturen — op één plek, zodat 'ie overal gelijk is.
    var shareText: String? {
        guard let reading else { return nil }
        let time = reading.date.formatted(date: .omitted, time: .shortened)
        return "Mijn hartslag is \(reading.bpm) bpm ❤️ (gemeten om \(time))"
    }
}
