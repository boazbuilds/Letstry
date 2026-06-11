import SwiftUI

// Het startpunt van de app: hier begint alles.
@main
struct HartslagApp: App {

    // De twee "helpers" van de app worden hier één keer aangemaakt en daarna
    // met álle schermen gedeeld. Zo is er één waarheid (single source of truth):
    // - health      praat met Apple Health
    // - friendsStore bewaart je vriendenlijst
    @StateObject private var health = HealthManager()
    @StateObject private var friendsStore = FriendsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(health)
                .environmentObject(friendsStore)
        }
    }
}
