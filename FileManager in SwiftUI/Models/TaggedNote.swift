//
//  TaggedNote.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation
import SwiftUI
import NMAUtilities

class TaggedNote: Note, Hashable {

    var manager: TagManager { .shared }
    var tags = Set<Tag>()

    let dateCreated = Date()

    required init(_ title: String, detail: String) {
        super.init(title, detail: detail)
    }

    init(note: Note, tags: [Tag]) {
        super.init(note.title, detail: note.detail)
        self.tags = Set(tags)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    func addTag(_ tag: Tag) {
        if tags.insert(tag).inserted {
            tag.linkNote(self)
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(dateCreated)
    }

}
