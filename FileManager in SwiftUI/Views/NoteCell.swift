//
//  NoteCell.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/27/21.
//

import SwiftUI
import NMAUtilities

struct NoteCell: View {
    
    // MARK: - Properties
    let note: Note
    
    // MARK: - UI Elements
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(note.title)")
                .font(.headline)
            
            Text("\(note.detail)")
                .font(.footnote)
                .lineLimit(2)
        }
    }
}


// MARK: - Previews
struct NoteListCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(note: note_1)
            .previewUpdateTime()
    }
}
