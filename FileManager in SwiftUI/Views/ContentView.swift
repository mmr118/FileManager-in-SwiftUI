//
//  ContentView.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/12/21.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties
    @ObservedObject var dataProvider = DataProvider.shared
    @State private var editMode: EditMode = .inactive
    @State private var isShowingCreateAlert = false
    @State private var titleText = String()
    @State private var detailText = String()

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    NoteListCell(note: note)
                }
                .onDelete(perform: dataProvider.delete)
                .onMove(perform: dataProvider.move)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("+") {
                        isShowingCreateAlert.toggle()
                    }
                }
            }
            .alert("Create Note", isPresented: $isShowingCreateAlert) {
                TextField("Title", text: $titleText)
                    .textInputAutocapitalization(.words)
                TextField("Details", text: $detailText)
                Button("OK", action: didTapSave)
                Button("Cancel", role: .cancel, action: resetNoteValues)
            } message: {
                Text("Add a title and some details.")
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
        }
    }

    private func didTapSave() {
        let newNote = Note(title: titleText, description: detailText)
        DataProvider.shared.create(note: newNote)
        resetNoteValues()
    }

    private func resetNoteValues() {
        titleText = String()
        detailText = String()
    }

}


// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataProvider: DataProvider.shared)
    }
}
