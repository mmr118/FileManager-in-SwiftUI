//
//  PreviewDataProvider.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import Foundation
import NMAUtilities
import SwiftUI

class PreviewDataProvider: DataProvider {
    
    fileprivate static let previewData: DataProvider = PreviewDataProvider()
    
    var bypassCreate: Bool = false
    var note_0: Note!
    var note_1: Note!
    var note_2: Note!

    init() {
        super.init()
        loadPreviewContent()
    }
    
    func loadPreviewContent() {
        if allNotes.isEmpty, allNotes.count < 3 {
            bypassCreate = false
            createPreviewNotes()
        } else {
            bypassCreate = true
        }
        assignNotes()
    }
    
    func createPreviewNotes() {
        for index in (0..<5) {
            let details = String.randomWords(10).joined(separator: " ").appending(".\n\n").appending(String.LoremIpsum)
            let newNote = Note(title: "Preview \(index)", description: details)
            create(note: newNote)
        }
    }
    
    func assignNotes() {
        let notes = allNotes
        assert(notes.count >= 3)
        self.note_0 = allNotes[0]
        self.note_1 = allNotes[1]
        self.note_2 = allNotes[2]
    }
    
}


// MARK: - PreviewProvider+DataProvider
extension PreviewProvider {
    
    static var Preview: DataProvider { PreviewDataProvider() }
    
    static var note_0: Note { (Preview as! PreviewDataProvider).note_0 }
    static var note_1: Note { (Preview as! PreviewDataProvider).note_1 }
    static var note_2: Note { (Preview as! PreviewDataProvider).note_2 }

}
