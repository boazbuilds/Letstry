import SwiftUI

// Dit is het "startpunt" van de app.
// Het @main-label vertelt iOS: hier begint alles.
// Zodra je op het app-icoon tikt, wordt dit als eerste uitgevoerd.
@main
struct HartslagApp: App {
    var body: some Scene {
        // Een WindowGroup is simpelweg "het scherm" van je app.
        // We laten daarin onze ContentView zien (zie ContentView.swift).
        WindowGroup {
            ContentView()
        }
    }
}
