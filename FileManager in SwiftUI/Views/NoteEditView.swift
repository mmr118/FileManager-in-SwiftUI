//
//  NoteEditView.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import SwiftUI
import NMAUtilities

struct NoteEditView: View {
    
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var dataProvider: DataProvider
    
    @State var title = String()
    @State var detail = String()
    
    var note: Note
    var isNewNote: Bool
    
    init(note: Note? = nil) {
        self.note = note ?? Note(title: "", detail: "")
        self.isNewNote = note == nil
    }

    var body: some View {
        Form {
            Section("") {
                TextField("Title", text: $title)
            }
            Section("") {
                TextEditor(text: $detail)
                    .frame(height: 200)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .destructive) {
                    dismiss.callAsFunction()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", role: .destructive) {
                    saveChanges()
                    dismiss.callAsFunction()
                }
                .disabled(title.isEmpty)
            }
        }
        .navigationTitle(note.title.isEmpty ? "New Note" : note.title)
        .onAppear {
            title = note.title
            detail = note.detail
        }
        
    }
    
    private func saveChanges() {
        let updatedNote = Note(id: note.id, title: title, detail: detail)
        dataProvider.updateNote(note: updatedNote)
    }

}


// MARK: - Previews
struct NoteEditView_Previews: PreviewProvider {
    
    static var showDetail = false
    
    static var previews: some View {
        BindingContent(showDetail) { binded in
            
            Button("Show") {
                binded.wrappedValue.toggle()
            }
            .sheet(isPresented: binded) {
                NavigationStack {
                    NoteEditView(note: note_0)
                        .environment(\.editMode, .constant(.inactive))
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .environmentObject(Preview)
        .previewUpdateTime()
    }

}
