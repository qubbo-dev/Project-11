import SwiftUI

struct NoteListView: View {
    @EnvironmentObject private var viewModel: NotesViewModel
    @State private var showingEditor = false
    @State private var noteToEdit: Note?

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                sortPicker
                if viewModel.filteredNotes().isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .navigationTitle("Poznámky")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: newNote) {
                        Label("Nová poznámka", systemImage: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingEditor, onDismiss: { noteToEdit = nil }) {
                NoteEditorView(note: noteToEdit) { title, body in
                    if let noteToEdit {
                        viewModel.update(note: noteToEdit, title: title, body: body)
                    } else {
                        viewModel.addNote(title: title, body: body)
                    }
                }
            }
        }
    }

    private var searchBar: some View {
        TextField("Hľadaj…", text: $viewModel.searchQuery)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
    }

    private var sortPicker: some View {
        Picker("Triedenie", selection: $viewModel.sortOrder) {
            ForEach(NotesViewModel.SortOrder.allCases) { order in
                Text(order.rawValue).tag(order)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: viewModel.sortOrder) { newValue in
            viewModel.changeSortOrder(newValue)
        }
    }

    private var list: some View {
        List {
            ForEach(viewModel.filteredNotes()) { note in
                Button {
                    edit(note)
                } label: {
                    NoteRowView(note: note)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteNotes)
        }
        .listStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            Text("Začni si zapisovať poznámky")
                .font(.headline)
            Text("Ťukni na tlačidlo hore a vytvor svoju prvú poznámku.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func deleteNotes(at offsets: IndexSet) {
        let filtered = viewModel.filteredNotes()
        let notesToDelete = offsets.map { filtered[$0] }
        viewModel.delete(notes: notesToDelete)
    }

    private func newNote() {
        noteToEdit = nil
        showingEditor = true
    }

    private func edit(_ note: Note) {
        noteToEdit = note
        showingEditor = true
    }
}

struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        let store = InMemoryNotesStore()
        let viewModel = NotesViewModel(store: store)
        return NoteListView()
            .environmentObject(viewModel)
    }
}
