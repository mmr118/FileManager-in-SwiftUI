//
//  NoteDetailView.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import SwiftUI
import NMAUtilities

struct NoteDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataProvider: DataProvider
    
    @State var isPresentingEditView = false
    
    var note: Note

    var body: some View {
        Form {
            detailText()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Edit") {
                    isPresentingEditView.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
//            NavigationStack {
                NoteEditView(note: note)
                    .environmentObject(dataProvider)
//            }
        }
        .navigationTitle(note.title)
    }
    
    @ViewBuilder private func detailText() -> some View {
        if note.description.isEmpty {
            Text("No details.")
                .foregroundStyle(.secondary)
        } else {
            Text(note.description)
        }
    }

}


// MARK: - Previews
struct NoteDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            NavigationLink("Show Detail") {
                NoteDetailView(note: note_0)
                    .environmentObject(Preview)
            }
        }
        .previewUpdateTime()
    }

}
