//
//  NoteDetailView.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import SwiftUI
import NMAUtilities

struct NoteDetailView: View {
    
    @EnvironmentObject var dataProvider: DataProvider
    
    var note: Note

    var body: some View {
        Text("Hello, World!")
    }

}


// MARK: - Previews
struct NoteDetailView_Previews: PreviewProvider {

    static var previews: some View {
        NoteDetailView(note: note_0)
            .environmentObject(Preview)
            .previewUpdateTime()
    }

}
