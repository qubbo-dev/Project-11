import Foundation

protocol NotesStoring {
    func load() throws -> [Note]
    func save(_ notes: [Note]) throws
}

final class NotesStore: NotesStoring {
    private let fileURL: URL
    private let queue = DispatchQueue(label: "NotesStoreQueue", qos: .background)

    init(fileURL: URL? = nil) {
        if let fileURL {
            self.fileURL = fileURL
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            self.fileURL = documentDirectory?.appendingPathComponent("notes.json") ?? URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("notes.json")
        }
    }

    func load() throws -> [Note] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Note].self, from: data)
    }

    func save(_ notes: [Note]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(notes)
        try queue.sync {
            try createDirectoryIfNeeded()
            try data.write(to: fileURL, options: .atomic)
        }
    }

    private func createDirectoryIfNeeded() throws {
        let directory = fileURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }
}
