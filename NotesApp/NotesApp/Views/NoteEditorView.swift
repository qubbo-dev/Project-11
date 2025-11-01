import SwiftUI

struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var body: String

    private let onSave: (String, String) -> Void

    init(note: Note?, onSave: @escaping (String, String) -> Void) {
        _title = State(initialValue: note?.title ?? "")
        _body = State(initialValue: note?.body ?? "")
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Nadpis")) {
                    TextField("Nadpis", text: $title)
                }

                Section(header: Text("Obsah")) {
                    TextEditor(text: $body)
                        .frame(minHeight: 240)
                }
            }
            .navigationTitle(title.isEmpty ? "Nová poznámka" : "Upraviť poznámku")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušiť") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložiť") {
                        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), body)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct NoteEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NoteEditorView(note: nil) { _, _ in }
    }
}
