import SwiftUI
import ContactsUI
import MessageUI

// In dit bestand staan twee "bruggen" naar oudere Apple-onderdelen die nog niet
// in SwiftUI zitten. We verpakken ze zodat we ze tóch als SwiftUI-scherm kunnen tonen.

// ─────────────────────────────────────────────────────────────────────────────
// BRUG 1 — Kies een contact uit je telefoonboek
// (Handig: deze kiezer vraagt GEEN aparte toestemming, want jij kiest zelf
//  expliciet één contact uit.)
// ─────────────────────────────────────────────────────────────────────────────
struct ContactPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onPick: (_ naam: String, _ nummer: String) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        // Alleen contacten mét een telefoonnummer zijn kiesbaar.
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        return picker
    }

    func updateUIViewController(_ vc: CNContactPickerViewController, context: Context) {}

    // De "coordinator" luistert naar wat de kiezer doet (gekozen / geannuleerd).
    final class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: ContactPicker
        init(_ parent: ContactPicker) { self.parent = parent }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let naam = "\(contact.givenName) \(contact.familyName)"
                .trimmingCharacters(in: .whitespaces)
            let nummer = contact.phoneNumbers.first?.value.stringValue ?? ""
            parent.onPick(naam.isEmpty ? "Vriend" : naam, nummer)
            parent.isPresented = false
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.isPresented = false
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// BRUG 2 — Open de Berichten-app met een kant-en-klaar bericht
// (Werkt alleen op een echte iPhone die sms/iMessage kan sturen.)
// ─────────────────────────────────────────────────────────────────────────────
struct MessageComposer: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let recipients: [String]   // naar wie het bericht gaat
    let body: String           // de tekst die alvast klaarstaat

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.messageComposeDelegate = context.coordinator
        vc.recipients = recipients
        vc.body = body
        return vc
    }

    func updateUIViewController(_ vc: MFMessageComposeViewController, context: Context) {}

    final class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let parent: MessageComposer
        init(_ parent: MessageComposer) { self.parent = parent }

        // Wordt aangeroepen als de gebruiker verstuurt of annuleert.
        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                          didFinishWith result: MessageComposeResult) {
            parent.isPresented = false
        }
    }
}
