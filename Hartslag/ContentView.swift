import SwiftUI
import MessageUI   // nodig om te checken of dit apparaat berichten kan sturen

// Dit is het hoofdscherm van de app.
struct ContentView: View {

    @StateObject private var health = HealthManager()   // tolk naar Health
    @StateObject private var store = FriendsStore()     // jouw vriendenlijst

    // Jouw eigen naam, zodat je vriend ziet van wie het verzoek komt.
    // @AppStorage bewaart dit automatisch op de telefoon.
    @AppStorage("mijnNaam") private var mijnNaam = ""

    // Schakelaars/keuzes voor de pop-up-schermen (sheets):
    @State private var showContactPicker = false        // contactkiezer open?
    @State private var friendToMessage: Friend?         // naar wie sturen we een verzoek?
    @State private var incomingRequest: HeartRateRequest?  // kreeg ik zelf een verzoek?
    @State private var kanGeenBericht = false           // apparaat kan geen sms sturen

    var body: some View {
        NavigationStack {
            List {

                // ── Sectie 1: jouw naam ────────────────────────────────
                Section("Jouw naam") {
                    TextField("Bijv. Boaz", text: $mijnNaam)
                }

                // ── Sectie 2: jouw eigen hartslag ──────────────────────
                Section("Mijn hartslag") {
                    if let bpm = health.latestHeartRate {
                        HStack {
                            Text("\(Int(bpm)) bpm")
                                .font(.title2).bold()
                                .foregroundStyle(.red)
                            Spacer()
                            ShareLink(item: "Mijn hartslag is \(Int(bpm)) bpm ❤️") {
                                Label("Delen", systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                    Button {
                        Task {
                            await health.requestAuthorization()
                            await health.fetchLatestHeartRate()
                        }
                    } label: {
                        Label("Hartslag ophalen", systemImage: "heart.fill")
                    }
                }

                // ── Sectie 3: vrienden ─────────────────────────────────
                Section("Mijn vrienden") {
                    if store.friends.isEmpty {
                        Text("Nog geen vrienden. Tik rechtsboven op + om er een toe te voegen.")
                            .foregroundStyle(.secondary)
                    }

                    ForEach(store.friends) { friend in
                        Button {
                            // Tikken op een vriend = een hartslag-verzoek sturen.
                            // Eerst checken of dit apparaat überhaupt sms/iMessage kan.
                            if MFMessageComposeViewController.canSendText() {
                                friendToMessage = friend
                            } else {
                                kanGeenBericht = true
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(friend.name).foregroundStyle(.primary)
                                    Text(friend.phone)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "paperplane")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .onDelete { store.remove(at: $0) }   // veeg naar links om te verwijderen
                }
            }
            .navigationTitle("❤️ Hartslag")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showContactPicker = true
                    } label: {
                        Label("Vriend toevoegen", systemImage: "plus")
                    }
                }
            }

            // Pop-up: kies een contact om als vriend toe te voegen.
            .sheet(isPresented: $showContactPicker) {
                ContactPicker(isPresented: $showContactPicker) { naam, nummer in
                    store.add(Friend(name: naam, phone: nummer))
                }
            }

            // Pop-up: stel het hartslag-verzoek op (Berichten-app).
            .sheet(item: $friendToMessage) { friend in
                MessageComposer(
                    isPresented: Binding(
                        get: { friendToMessage != nil },
                        set: { if !$0 { friendToMessage = nil } }
                    ),
                    recipients: [friend.phone],
                    body: verzoekBericht()
                )
            }

            // Pop-up: een binnengekomen verzoek (als iemand jou de link stuurt).
            .sheet(item: $incomingRequest) { req in
                RequestView(fromName: req.fromName)
            }

            // Melding als het apparaat geen berichten kan sturen.
            .alert("Geen berichten mogelijk", isPresented: $kanGeenBericht) {
                Button("Oké", role: .cancel) {}
            } message: {
                Text("Dit apparaat kan geen sms/iMessage sturen. Probeer het op een echte iPhone.")
            }

            // Vraag bij opstarten netjes om toestemming voor Health.
            .task { await health.requestAuthorization() }

            // Vang inkomende "hartslag://"-links op en open het verzoek-scherm.
            .onOpenURL { url in
                if let req = HeartRateRequest(url: url) {
                    incomingRequest = req
                }
            }
        }
    }

    // Het berichtje dat je vriend ontvangt als je op zijn naam tikt.
    private func verzoekBericht() -> String {
        let naam = mijnNaam.isEmpty ? "een vriend" : mijnNaam
        let gecodeerd = naam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? naam
        return """
        Hoi! Wat is jouw hartslag? ❤️
        Open de Hartslag-app om te antwoorden:
        hartslag://verzoek?van=\(gecodeerd)
        """
    }
}

// Een "binnengekomen verzoek", gemaakt uit een link zoals: hartslag://verzoek?van=Boaz
struct HeartRateRequest: Identifiable {
    let id = UUID()
    let fromName: String

    init(fromName: String) {
        self.fromName = fromName
    }

    // Probeert een verzoek te maken uit een URL. Lukt dat niet, dan geeft 'ie nil terug.
    init?(url: URL) {
        guard url.scheme == "hartslag", url.host == "verzoek" else { return nil }
        let comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let van = comps?.queryItems?.first(where: { $0.name == "van" })?.value
        self.fromName = (van?.isEmpty == false) ? van! : "Iemand"
    }
}

#Preview {
    ContentView()
}
