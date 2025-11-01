import Foundation

final class InMemoryNotesStore: NotesStoring {
    private var notes: [Note]

    init(notes: [Note] = []) {
        self.notes = notes
    }

    func load() throws -> [Note] {
        notes
    }

    func save(_ notes: [Note]) throws {
        self.notes = notes
    }
}
