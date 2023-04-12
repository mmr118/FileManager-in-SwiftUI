//
//  Tag.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import SwiftUI

class Tag: Equatable, Hashable, Identifiable {

    var manager: TagManager { .shared }

    var title: String
    var color: Color

    var id: String { title }

    var linkedNoteIds = Set<UUID>()

    init(_ title: String, color: Color = Color.Crayon.allCases.randomElement()!.color) {
        self.title = title
        self.color = color
    }

    @discardableResult
    public func linkNote(_ note: Note) -> Bool {
        let result = linkedNoteIds.insert(note.id)
        return result.inserted
    }

    @discardableResult
    public func unlinkNote(_ note: Note) -> UUID? {
        let result = linkedNoteIds.remove(note.id)
        return result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.title == rhs.title
    }

}
