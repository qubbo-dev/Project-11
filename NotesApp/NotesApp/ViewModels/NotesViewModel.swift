import Foundation

@MainActor
final class NotesViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    @Published var searchQuery: String = ""
    @Published var sortOrder: SortOrder = .byUpdated

    enum SortOrder: String, CaseIterable, Identifiable {
        case byUpdated = "Najnovšie"
        case byCreated = "Najstaršie"
        case alphabetical = "Abecedne"

        var id: String { rawValue }
    }

    private let store: NotesStoring

    init(store: NotesStoring) {
        self.store = store
        Task {
            await loadNotes()
        }
    }

    func loadNotes() async {
        do {
            let loaded = try store.load()
            notes = sortNotes(loaded)
        } catch {
            notes = []
        }
    }

    func addNote(title: String, body: String) {
        var note = Note(title: title, body: body)
        note.updatedAt = Date()
        notes.insert(note, at: 0)
        persist()
    }

    func update(note: Note, title: String, body: String) {
        guard let index = notes.firstIndex(of: note) else { return }
        var updated = note
        updated.title = title
        updated.body = body
        updated.updatedAt = Date()
        notes[index] = updated
        notes = sortNotes(notes)
        persist()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        persist()
    }

    func delete(notes notesToDelete: [Note]) {
        guard !notesToDelete.isEmpty else { return }
        let ids = Set(notesToDelete.map(\.id))
        notes.removeAll { ids.contains($0.id) }
        persist()
    }

    func filteredNotes() -> [Note] {
        let filtered: [Note]
        if searchQuery.isEmpty {
            filtered = notes
        } else {
            let query = searchQuery.lowercased()
            filtered = notes.filter { note in
                note.title.lowercased().contains(query) || note.body.lowercased().contains(query)
            }
        }
        return sortNotes(filtered)
    }

    func changeSortOrder(_ order: SortOrder) {
        sortOrder = order
        notes = sortNotes(notes)
    }

    private func sortNotes(_ notes: [Note]) -> [Note] {
        switch sortOrder {
        case .byUpdated:
            return notes.sorted { $0.updatedAt > $1.updatedAt }
        case .byCreated:
            return notes.sorted { $0.createdAt < $1.createdAt }
        case .alphabetical:
            return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }

    private func persist() {
        Task.detached(priority: .background) { [notes] in
            do {
                try store.save(notes)
            } catch {
                #if DEBUG
                print("Failed to save notes: \(error)")
                #endif
            }
        }
    }
}
