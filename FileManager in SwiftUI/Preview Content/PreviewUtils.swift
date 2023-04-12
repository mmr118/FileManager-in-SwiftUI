//
//  PreviewUtils.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import SwiftUI
import NMAUtilities

struct PreviewDataFiller {
    static let tempDirPath = NSTemporaryDirectory()
    static let tempDir = URL(fileURLWithPath: tempDirPath, isDirectory: true)
    static let previewDir = tempDir.appendingPathComponent("preview_data")

    static func fillData<T: Note>(_ values: [T]) throws {
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(values)
        try data.write(to: previewDir)
        
    }

    static func createTaggedNotes(count: Int = 5) -> [TaggedNote] {
        var results = [TaggedNote]()
        for note in createNotes(count: count) {
            let count = Int.random(in: 0..<3)
            let tags = (0..<count).map { _ in Tag(String.randomWord()) }
            let tagged = TaggedNote(note: note, tags: tags)
            results.append(tagged)
        }
        printFFL("taggedNotes count: \(results.count)")
        return results

    }

    static func createNotes(count: Int = 5) -> [Note] {
        let results = (0..<5).map { Note("\(String.randomWord()) \($0)" , detail: String.randomWords(5).joined(separator: " ")) }
        printFFL("notes count: \(results.count)")
        return results
    }

}

class PreviewStorageManager<T>: StorageManager<T> where T: Note {


    init() {
        super.init(rootDir: PreviewDataFiller.previewDir)
    }

//    func loadPreviewData() { }
//
//    func createTaggedNotes(count: Int = 5) -> [T] {
//
//        var results = [T]()
//
//        for note in createNotes(count: count) {
//            let count = Int.random(in: 0..<3)
//            let tags = (0..<count).map { _ in Tag(String.randomWord()) }
//            let tagged = TaggedNote(note: note, tags: tags)
//            if let value = tagged as? T {
//                results.append(value)
//            }
//        }
//
//        printFFL("taggedNotes count: \(results.count)")
//
//        return results
//
//    }
//
//    func createNotes(count: Int = 5) -> [T] {
//        let notes = (0..<5).map { Note("\(String.randomWord()) \($0)" , detail: String.randomWords(5).joined(separator: " ")) }
//        let results = notes.compactMap { $0 as? T }
//        printFFL("notes count: \(results.count)")
//        return results
//    }

}

class NotePreviewStorageManager: PreviewStorageManager<Note> {

    override init() {
        var fillerError: Error? = nil
        let notes = PreviewDataFiller.createNotes()
        do {
            try PreviewDataFiller.fillData(notes)
        } catch {
            fillerError = error
            printFFL(error.localizedDescription)
        }

        super.init()
        self.error = fillerError
    }

}

class TaggedPreviewStorageManager: PreviewStorageManager<TaggedNote> {

    override init() {
        var fillerError: Error? = nil
        let notes = PreviewDataFiller.createTaggedNotes()
        do {
            try PreviewDataFiller.fillData(notes)
        } catch {
            fillerError = error
            printFFL(error.localizedDescription)
        }

        super.init()
        self.error = fillerError
    }

}


// MARK: - PreviewProvider+Helpers
extension PreviewProvider {

    static func storageManager<T: Codable & Equatable>() -> StorageManager<T> {
        return PreviewStorageManager<T>()
    }

//    static var taggedNoteManager: StorageManager<TaggedNote> { PreviewStorageManager.TaggedNotes }
//    static var noteManager: StorageManager<Note> { PreviewStorageManager.Notes }

}
