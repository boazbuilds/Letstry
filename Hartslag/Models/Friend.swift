import Foundation

// Eén vriend: een naam en een telefoonnummer.
// - Codable      -> kan als tekst (JSON) opgeslagen worden, zodat we 'm bewaren.
// - Identifiable -> SwiftUI kan vrienden uit elkaar houden in een lijst.
struct Friend: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var phone: String

    // De eerste letters van voor- en achternaam, voor het gekleurde rondje.
    var initials: String {
        let letters = name.split(separator: " ").prefix(2).compactMap(\.first)
        return letters.isEmpty ? "?" : String(letters)
    }
}

// Bewaart de vriendenlijst op de telefoon, ook nadat je de app afsluit.
@MainActor
final class FriendsStore: ObservableObject {

    // De lijst met vrienden. Telkens als deze verandert, slaan we 'm op.
    @Published var friends: [Friend] = [] {
        didSet { save() }
    }

    // De "naam" waaronder we de lijst bewaren in het geheugen van de app.
    private let storageKey = "saved_friends"

    init() {
        load()   // bij het opstarten: eerder bewaarde vrienden terughalen
    }

    func add(_ friend: Friend) {
        // Voeg niet twee keer hetzelfde nummer toe.
        guard !friends.contains(where: { $0.phone == friend.phone }) else { return }
        friends.append(friend)
    }

    func remove(at offsets: IndexSet) {
        friends.remove(atOffsets: offsets)
    }

    // MARK: - Opslaan & laden (UserDefaults = het kleine kladblok van de app)

    private func save() {
        if let data = try? JSONEncoder().encode(friends) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let saved = try? JSONDecoder().decode([Friend].self, from: data)
        else { return }
        friends = saved
    }
}
