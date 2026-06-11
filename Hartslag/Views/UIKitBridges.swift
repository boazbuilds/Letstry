import SwiftUI
import Contacts
import ContactsUI
import MessageUI

// Twee oudere (UIKit-)onderdelen van iOS bestaan nog niet in SwiftUI:
// de contactenkiezer en het opstel-scherm van Berichten. Hier verpakken
// we ze ("bridge"), zodat we ze tóch als SwiftUI-pop-up kunnen tonen.

// MARK: - Contact kiezen

// Fijn om te weten: deze kiezer vraagt GEEN toestemming voor je contacten,
// omdat jij zelf expliciet één contact aanwijst.
struct ContactPicker: UIViewControllerRepresentable {

    var onPick: (_ name: String, _ phone: String) -> Void
    var onCancel: () -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        // Alleen contacten mét een telefoonnummer zijn aanklikbaar.
        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        return picker
    }

    func updateUIViewController(_ picker: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    // De "coordinator" luistert naar wat de kiezer doet (gekozen of geannuleerd).
    final class Coordinator: NSObject, CNContactPickerDelegate {
        private let parent: ContactPicker
        init(_ parent: ContactPicker) { self.parent = parent }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let name = "\(contact.givenName) \(contact.familyName)"
                .trimmingCharacters(in: .whitespaces)
            let phone = contact.phoneNumbers.first?.value.stringValue ?? ""
            parent.onPick(name.isEmpty ? "Vriend" : name, phone)
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.onCancel()
        }
    }
}

// MARK: - Berichten-opstelscherm

// Opent het bekende groene/blauwe berichten-scherm met tekst en ontvanger
// alvast ingevuld. Versturen doet de gebruiker zelf — wel zo netjes.
struct MessageComposer: UIViewControllerRepresentable {

    let recipients: [String]
    let body: String
    var onFinish: () -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = recipients
        composer.body = body
        return composer
    }

    func updateUIViewController(_ composer: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        private let parent: MessageComposer
        init(_ parent: MessageComposer) { self.parent = parent }

        // Wordt aangeroepen als de gebruiker het bericht verstuurt of annuleert.
        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                          didFinishWith result: MessageComposeResult) {
            parent.onFinish()
        }
    }
}
