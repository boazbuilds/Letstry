import Foundation

// Eén vriend = een naam en een telefoonnummer.
// - Codable    -> kan opgeslagen worden als tekst (JSON), zodat we 'm bewaren.
// - Identifiable -> SwiftUI kan ze netjes uit elkaar houden in een lijst.
struct Friend: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var phone: String
}

// Deze klasse bewaart je vriendenlijst op de telefoon
// en onthoudt 'm ook nadat je de app afsluit.
@MainActor
final class FriendsStore: ObservableObject {

    // De lijst met vrienden. Telkens als deze verandert, slaan we 'm op.
    @Published var friends: [Friend] = [] {
        didSet { save() }
    }

    // De "naam" waaronder we de lijst bewaren in het geheugen van de app.
    private let opslagSleutel = "bewaarde_vrienden"

    init() {
        load()   // bij het opstarten: eerder bewaarde vrienden terughalen
    }

    func add(_ friend: Friend) {
        // Voeg niet 2x hetzelfde nummer toe.
        guard !friends.contains(where: { $0.phone == friend.phone }) else { return }
        friends.append(friend)
    }

    func remove(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
    }

    // --- Opslaan & laden via UserDefaults (een klein "kladblokje" per app) ---

    private func save() {
        if let data = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(data, forKey: opslagSleutel)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: opslagSleutel),
            let bewaard = try? JSONDecoder().decode([Friend].self, from: data)
        else { return }
        friends = bewaard
    }
}
