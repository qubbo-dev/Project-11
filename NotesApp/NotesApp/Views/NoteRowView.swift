import SwiftUI

struct NoteRowView: View {
    let note: Note

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title.isEmpty ? "Bez názvu" : note.title)
                .font(.headline)
                .foregroundColor(.primary)
            if !note.previewText.isEmpty {
                Text(note.previewText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Text("Upravené: \(Self.formatter.string(from: note.updatedAt))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(note: Note(title: "Nakupovanie", body: "Mlieko\nMaslo\nChlieb"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
