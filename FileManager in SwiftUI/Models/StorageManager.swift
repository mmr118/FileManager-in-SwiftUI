//
//  StorageManager.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import SwiftUI

protocol FileManagerCoordinator: ObservableObject {

    associatedtype T: Note

    var values: [T] { get set }
    var error: Error? { get set }

    func save(_ value: T)
    func delete(_ offsets: IndexSet)
    func update(_ newValue: T, at index: Int)
    func load()
}

class StorageManager<T>: ObservableObject, FileManagerCoordinator where T: Note {

    var fileManager: FileManager { .default }

    var basePathComponent: String

    var rootDir: URL

    @Published var error: Error?

    @Published var values: [T] = []

    init(rootDir: URL) {
        self.rootDir = rootDir
        self.basePathComponent = rootDir.lastPathComponent

        let allValues: [T]
        switch getAllValues() {
        case .success(let values):
            allValues = values
        case .failure(let error):
            printFFL(#line, error.localizedDescription)
            allValues = []
        }

        self._values = Published(wrappedValue: allValues)
    }

    convenience init(base: String) {
        let baseURL = URL.documentsDirectory.appendingPathComponent(base)
        self.init(rootDir: baseURL)
    }

    public func save(_ value: T) {
        values.insert(value, at: 0)
        saveValues()
    }

    public func delete(_ offsets: IndexSet) {
        values.remove(atOffsets: offsets)
        saveValues()
    }

    public func delete(_ value: T) -> T? {
        var result: T? = nil
        if let indexToRemove = values.firstIndex(where: { $0 == value }) {
            result = values.remove(at: indexToRemove)
        }
        saveValues()
        return result
    }

    public func update(_ newValue: T, at index: Int) {
        values[index] = newValue
        saveValues()
    }

    public func update(_ newValue: T, with id: T.ID) where T: Identifiable {
        if let index = values.firstIndex(where: { $0.id == id }) {
            update(newValue, at: index)
        }
    }

    func getAllValues() ->  Result<[T], Error> {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: rootDir)
            let result = try decoder.decode([T].self, from: data)
            return .success(result)
        } catch {
            self.error = error
            return .failure(error)
        }
    }

    @discardableResult
    private func saveValues() -> Result<Data, Error> {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(values)
            try data.write(to: rootDir)
            return .success(data)
        } catch {
            self.error = error
            return .failure(error)
        }
    }

    func load() {
        switch getAllValues() {
        case .success(let results):
            self._values = Published(wrappedValue: results)
        case .failure(let error):
            self._values = Published(wrappedValue: [])
            self.error = error
        }

    }

}


class NoteStorageManager: StorageManager<Note> { }
class TaggedStorageManager: StorageManager<TaggedNote> { }
