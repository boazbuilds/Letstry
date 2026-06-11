import Foundation

// Alles over de speciale "hartslag://"-links staat hier bij elkaar:
// het MAKEN van zo'n link (als jij een verzoek stuurt) en het LEZEN
// ervan (als zo'n link bij jou binnenkomt).
struct HeartRateRequest: Identifiable {
    let id = UUID()
    let fromName: String

    static let scheme = "hartslag"
    static let host = "verzoek"

    init(fromName: String) {
        self.fromName = fromName
    }

    // Probeert een binnengekomen link te lezen.
    // Is het geen geldige verzoek-link? Dan geeft dit nil terug.
    init?(url: URL) {
        guard let parts = URLComponents(url: url, resolvingAgainstBaseURL: false),
              parts.scheme == Self.scheme,
              parts.host == Self.host
        else { return nil }

        let name = parts.queryItems?.first(where: { $0.name == "van" })?.value
        self.fromName = (name?.isEmpty == false) ? name! : "Iemand"
    }

    // Bouwt de link, bijvoorbeeld: hartslag://verzoek?van=Boaz
    // URLComponents codeert rare tekens (spaties, &) automatisch goed —
    // veiliger dan zelf een tekst aan elkaar plakken.
    static func url(from senderName: String) -> URL {
        var parts = URLComponents()
        parts.scheme = scheme
        parts.host = host
        parts.queryItems = [URLQueryItem(name: "van", value: senderName)]
        return parts.url!
    }

    // Het complete berichtje dat in Berichten voor je wordt klaargezet.
    static func messageBody(from senderName: String) -> String {
        let sender = senderName.isEmpty ? "Een vriend" : senderName
        return """
        Hoi! Wat is jouw hartslag? ❤️
        Heb je de Hartslag-app? Open dan deze link:
        \(url(from: sender).absoluteString)
        """
    }
}
