//
//  TagManager.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation

struct TagManager {
    static let shared = TagManager()

    var tagNoteDict = [Tag: Set<TaggedNote>]()

    private init() { }

    @discardableResult
    public mutating func trackTag(_ tag: Tag, for taggedNote: TaggedNote) -> Bool {
        if let result = tagNoteDict[tag]?.insert(taggedNote) {
            return result.inserted
        } else {
            tagNoteDict[tag] = Set([taggedNote])
            return true
        }
    }

    @discardableResult
    mutating func removeTag(_ tag: Tag, from taggedNote: TaggedNote) -> TaggedNote? {
        return tagNoteDict[tag]?.remove(taggedNote)
    }

    func notes(for tag: Tag) -> [TaggedNote] {
        return tagNoteDict[tag]?.map { $0 } ?? []
    }
}
