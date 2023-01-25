//
//  DataProvider.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

class DataProvider: ObservableObject {
    
    // MARK: - Properties
    private static let _shared = DataProvider()
    class var shared: DataProvider { _shared }
    
    private let dataSourceURL: URL
    @Published var allNotes = [Note]()
    
    // MARK: - Life Cycle
    init(fileManager: FileManager = .default) {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
        dataSourceURL = notesPath
        
        _allNotes = Published(wrappedValue: getAllNotes())
    }
    
    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedNotes = try decoder.decode([Note].self, from: data)
            
            return decodedNotes
        } catch {
            return []
        }
    }
    
    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    @discardableResult
    func create(note: Note) -> Bool {
        guard !allNotes.contains(where: { $0.id == note.id }) else { return false }
        allNotes.insert(note, at: 0)
        saveNotes()
        return true
    }
    
    func changeNote(note: Note, at index: Int) {
        allNotes[index] = note
        saveNotes()
    }

    @discardableResult
    func updateNote(note: Note) -> Bool {
        guard let index = allNotes.firstIndex(where: { $0.id == note.id }) else { return false }
        changeNote(note: note, at: index)
        return true
    }

    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
}
