import SwiftUI

@main
struct NotesApp: App {
    @StateObject private var viewModel = NotesViewModel(store: NotesStore())

    var body: some Scene {
        WindowGroup {
            NoteListView()
                .environmentObject(viewModel)
        }
    }
}
