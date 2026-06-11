import SwiftUI

// Eén regel in de vriendenlijst: gekleurd rondje met initialen + naam + nummer.
struct FriendRow: View {

    let friend: Friend

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.gradient)
                Text(friend.initials)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .frame(width: 40, height: 40)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.name)
                    .foregroundStyle(.primary)
                Text(friend.phone)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "paperplane.fill")
                .foregroundStyle(Color.accentColor)
                .accessibilityHidden(true)
        }
        // Zo is de hele regel tikbaar, ook de "lege" ruimte in het midden.
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        FriendRow(friend: Friend(name: "Sanne de Vries", phone: "06 12345678"))
        FriendRow(friend: Friend(name: "Mo", phone: "06 87654321"))
    }
}
