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
    
    var event_0: Event!
    var event_1: Event!
    var event_2: Event!

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

    func createPreviewEvents() {
        for index in (0..<5) {
            let details = String.randomWords(10).joined(separator: " ").appending(".\n\n")
            let newEvent = Event("Preview Event \(index)", detail: details)
            createEvent(newEvent)
        }
    }

    func assignNotes() {
        let notes = allNotes
        assert(notes.count >= 3)
        self.note_0 = allNotes[0]
        self.note_1 = allNotes[1]
        self.note_2 = allNotes[2]
    }

    func assignEvents() {
        let notes = allNotes
        assert(notes.count >= 3)
        self.event_0 = allEvents[0]
        self.event_1 = allEvents[1]
        self.event_2 = allEvents[2]
    }

}


// MARK: - PreviewProvider+DataProvider
extension PreviewProvider {
    
    static var Preview: DataProvider { PreviewDataProvider() }
    
    static var note_0: Note { (Preview as! PreviewDataProvider).note_0 }
    static var note_1: Note { (Preview as! PreviewDataProvider).note_1 }
    static var note_2: Note { (Preview as! PreviewDataProvider).note_2 }

}
