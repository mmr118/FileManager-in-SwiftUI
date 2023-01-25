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
    
    
    private var fileManager: FileManager { .default }
    private var documentsDir: URL { fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] }
//    private var notesDir: URL { documentsDir.appendingPathComponent("notes").appendingPathExtension("json") }
    private lazy var notesPath: URL = documentsDir.appendingPathComponent("notes").appendingPathExtension("json")
    private lazy var eventsPath: URL = documentsDir.appendingPathComponent("events").appendingPathExtension("json")

    @Published var allNotes = [Note]()
    @Published var allEvents = [Event]()

    // MARK: - Life Cycle
    init(fileManager: FileManager = .default) {
        _allNotes = Published(wrappedValue: getAllNotes())
        _allEvents = Published(wrappedValue: getAllEvents())
    }
    
    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: notesPath)
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
            try data.write(to: notesPath)
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

    func deleteNote(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func moveNote(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
    
    
    private func getAllEvents() -> [Event] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: eventsPath)
            let decodedNotes = try decoder.decode([Event].self, from: data)
            
            return decodedNotes
        } catch {
            return []
        }
    }

    private func saveEvents() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allEvents)
            try data.write(to: eventsPath)
        } catch {

        }
    }
    
    @discardableResult
    func createEvent(_ event: Event) -> Bool {
        guard !allEvents.contains(where: { $0.id == event.id }) else { return false }
        allEvents.insert(event, at: 0)
        saveEvents()
        return true
    }
    
    func changeEvent(_ event: Event, at index: Int) {
        allEvents[index] = event
        saveEvents()
    }

    @discardableResult
    func updateEvent(_ event: Event) -> Bool {
        guard let index = allEvents.firstIndex(where: { $0.id == event.id }) else { return false }
        changeEvent(event, at: index)
        return true
    }

    func deleteEvent(_ offsets: IndexSet) {
        allEvents.remove(atOffsets: offsets)
        saveEvents()
    }
    
    func moveEvent(source: IndexSet, destination: Int) {
        allEvents.move(fromOffsets: source, toOffset: destination)
        saveEvents()
    }
    


}
