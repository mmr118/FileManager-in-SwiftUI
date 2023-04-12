//
//  Note.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

class Note: Codable, Identifiable, Equatable {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let detail: String

    required init(_ title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }

}


class UserNote: Codable, Identifiable, Equatable {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let detail: String
    let user: User
    
    init(user: User, _ title: String, detail: String) {
        self.user = user
        self.title = title
        self.detail = detail
    }
    
    public static func ==(lhs: UserNote, rhs: UserNote) -> Bool {
        return lhs.id == rhs.id
    }
    
}
