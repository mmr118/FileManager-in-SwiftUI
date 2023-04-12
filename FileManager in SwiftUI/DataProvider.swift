//
//  DataProvider.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

class DataProvider: ObservableObject {
    
    // MARK: - Properties
    static let shared = DataProvider()

    var fileManager: FileManager { .default }

    private var documentDirURL: URL { fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] }

    private var baseDirURL: URL { documentDirURL.appendingPathExtension("demo") }

    private var notesURL: URL { baseDirURL.appendingPathComponent("notes").appendingPathExtension("json") }
    private var eventsDirURL: URL { baseDirURL.appendingPathComponent("MTG2Doc").appendingPathExtension("json") }

    @Published var allDatum = [(any Datum)]()
    @Published var allNotes = [Note]()
    @Published var allEvents = [M2DEvent]()

    // MARK: - Life Cycle
    init() {
        _allNotes = Published(wrappedValue: getAllNotes())
    }
    
    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: notesURL)
            let decodedNotes = try decoder.decode([Note].self, from: data)
            return decodedNotes
        } catch {
            print(error.localizedDescription)
            print((error as NSError).userInfo)
            return []
        }
    }
    
    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: notesURL)
        } catch {
            print(error.localizedDescription)
            print((error as NSError).userInfo)
        }
    }
    
    func create(note: Note) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }
    
    func changeNote(note: Note, index: Int) {
        allNotes[index] = note
        saveNotes()
    }
    
    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }

//    do {
//        let decoder = PropertyListDecoder()
//        let data = try Data(contentsOf: notesURL)
//        let decodedNotes = try decoder.decode([Note].self, from: data)
//        return decodedNotes
//    } catch {
//        print(error.localizedDescription)
//        print((error as NSError).userInfo)
//        return []
//    }
}
