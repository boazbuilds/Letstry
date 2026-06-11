import SwiftUI
import MessageUI

// Het hoofdscherm: je eigen hartslag, je vrienden en je naam.
// Dit scherm blijft bewust "dun": de losse onderdelen (kaart, vriend-regel)
// staan in eigen bestandjes, en alle Health-logica zit in HealthManager.
struct ContentView: View {

    // De gedeelde helpers, aangemaakt in HartslagApp.swift.
    @EnvironmentObject private var health: HealthManager
    @EnvironmentObject private var friendsStore: FriendsStore

    // Jouw naam; @AppStorage bewaart die automatisch op de telefoon.
    @AppStorage("myName") private var myName = ""

    // Welke pop-up staat er open?
    @State private var showContactPicker = false          // contactenkiezer
    @State private var friendToAsk: Friend?               // verzoek opstellen voor...
    @State private var incomingRequest: HeartRateRequest? // iemand vraagt JOU iets
    @State private var showCannotSendAlert = false        // apparaat kan niet sms'en

    var body: some View {
        NavigationStack {
            List {
                // ── Jouw hartslag, groot bovenaan ─────────────────────
                Section {
                    HeartRateCard()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                // ── Vrienden ──────────────────────────────────────────
                Section {
                    if friendsStore.friends.isEmpty {
                        ContentUnavailableView {
                            Label("Nog geen vrienden", systemImage: "person.2")
                        } description: {
                            Text("Tik rechtsboven op + om een vriend uit je contacten toe te voegen.")
                        }
                    }

                    ForEach(friendsStore.friends) { friend in
                        Button {
                            askHeartRate(of: friend)
                        } label: {
                            FriendRow(friend: friend)
                        }
                        .accessibilityHint("Stuurt een hartslag-verzoek via Berichten")
                    }
                    .onDelete { friendsStore.remove(at: $0) }
                } header: {
                    Text("Mijn vrienden")
                } footer: {
                    if !friendsStore.friends.isEmpty {
                        Text("Tik op een vriend om naar zijn of haar hartslag te vragen. Veeg naar links om iemand te verwijderen.")
                    }
                }

                // ── Jouw naam ─────────────────────────────────────────
                Section {
                    TextField("Bijv. Boaz", text: $myName)
                        .textContentType(.givenName)
                } header: {
                    Text("Jouw naam")
                } footer: {
                    Text("Deze naam ziet je vriend staan bij jouw verzoek.")
                }
            }
            .navigationTitle("Hartslag")
            // Naar beneden trekken = verversen, net als in Mail.
            .refreshable { await health.fetchLatestHeartRate() }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showContactPicker = true
                    } label: {
                        Label("Vriend toevoegen", systemImage: "plus")
                    }
                }
            }

            // Pop-up: een contact kiezen om als vriend toe te voegen.
            .sheet(isPresented: $showContactPicker) {
                ContactPicker { name, phone in
                    friendsStore.add(Friend(name: name, phone: phone))
                    showContactPicker = false
                } onCancel: {
                    showContactPicker = false
                }
            }

            // Pop-up: het verzoek-berichtje opstellen (Berichten-app).
            .sheet(item: $friendToAsk) { friend in
                MessageComposer(
                    recipients: [friend.phone],
                    body: HeartRateRequest.messageBody(from: myName)
                ) {
                    friendToAsk = nil
                }
                .ignoresSafeArea()
            }

            // Pop-up: een binnengekomen verzoek (iemand opende jouw link... of jij die van hen).
            .sheet(item: $incomingRequest) { request in
                RequestView(request: request)
                    .presentationDetents([.medium, .large])
            }

            .alert("Berichten niet beschikbaar", isPresented: $showCannotSendAlert) {
                Button("Oké", role: .cancel) {}
            } message: {
                Text("Dit apparaat kan geen berichten sturen. Probeer het op een echte iPhone.")
            }

            // Bij het openen van de app: meteen netjes om toestemming vragen.
            .task { await health.requestAuthorization() }

            // Vangt "hartslag://"-links op en opent dan het verzoek-scherm.
            .onOpenURL { url in
                if let request = HeartRateRequest(url: url) {
                    incomingRequest = request
                }
            }
        }
    }

    // Tikken op een vriend = een hartslag-verzoek sturen.
    // Eerst checken of dit apparaat überhaupt berichten kan versturen.
    private func askHeartRate(of friend: Friend) {
        if MFMessageComposeViewController.canSendText() {
            friendToAsk = friend
        } else {
            showCannotSendAlert = true
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthManager())
        .environmentObject(FriendsStore())
}
