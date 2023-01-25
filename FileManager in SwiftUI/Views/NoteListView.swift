//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI
import NMAUtilities
import NMASFSymbol

struct NoteListView: View {

    // MARK: - Properties
    @Environment(\.editMode) var editMode
    
    @EnvironmentObject var dataProvider: DataProvider
    
    @State private var alertShowing = false
    @State private var noteTitle = String()
    @State private var noteDetails = String()
    
    @State private var newNote: Note?

    // MARK: - UI Elements
    var body: some View {
        
        NavigationStack {
            
            List {
                ForEach(dataProvider.allNotes) { note in
                    NavigationLink(value: note) {
                        NoteCell(note: note)
                    }
                }
                .onDelete(perform: dataProvider.delete)
                .onMove(perform: dataProvider.move)
            }
            .navigationDestination(for: Note.self, destination: { selectedNote in
                NoteDetailView(note: selectedNote)
                    .environmentObject(dataProvider)
            })
            .listStyle(InsetListStyle())
            .sheet(item: $newNote, content: { note in
                NavigationStack {
                    NoteDetailView(note: note)
                        .environmentObject(dataProvider)
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    createNoteButton()
                }
            }
            .alert("New Note", isPresented: $alertShowing) {
                createNoteAlertView()
            }
            .navigationTitle("Notes")
            .environment(\.editMode, editMode)
        }
    }
    
    @ViewBuilder private func createNoteAlertView() -> some View {
        TextField("Title", text: $noteTitle)
        TextEditor(text: $noteDetails)
        Button("Cancel") {
            resetNoteValues()
        }
        Button("Save") {
            saveNote()
            resetNoteValues()
        }
    }
    
    @ViewBuilder private func createNoteButton() -> some View {
        Button(symbol: .plus) {
            withAnimation {
                alertShowing.toggle()
            }
        }
        .disabled(editMode?.wrappedValue.isEditing ?? false)
    }
    
    private func resetNoteValues() {
        noteTitle = String()
        noteDetails = String()
    }
    
    private func saveNote() {
        let newNote = Note(title: noteTitle, description: noteDetails)
        dataProvider.create(note: newNote)
    }
}


// MARK: - Previews
struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NoteListView()
        }
        .environmentObject(DataProvider.shared)
        .previewUpdateTime()
    }
}
