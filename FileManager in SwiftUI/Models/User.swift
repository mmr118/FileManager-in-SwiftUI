//
//  User.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation


struct User: Codable, Hashable, Equatable {

    static let user_0 = User(id: UUID(uuidString: "43BB1B63-67AE-4640-9DBF-EDF2880B8D40")!, name: "Cory")
    static let user_1 = User(id: UUID(uuidString: "CF540CC2-376A-4C12-917D-AA6A2C50E056")!, name: "Eddie")
    static let user_2 = User(id: UUID(uuidString: "48D1E774-B420-428C-B308-E7DAE9FF324C")!, name: "Lena")
    static let user_3 = User(id: UUID(uuidString: "AE06D2CA-2244-4653-982F-4C8D15FEE14A")!, name: "Tyree")
    static let user_4 = User(id: UUID(uuidString: "CF71FD0C-D7CF-4BE5-8C0F-FC8342F48D48")!, name: "Frankie")

    static let allUsers = [user_0, user_1, user_2, user_3, user_4]

    var id: UUID
    var name: String

    init(id: UUID = .init(), name: String) {
        self.id = id
        self.name = name
    }

    enum Tab: String, CaseIterable {
        case all
        case cory
        case eddie
        case lena
        case tyree
        case frankie

        func users() -> [User] {
            if self == .all {
                return User.allUsers
            } else {
                return [User.allUsers.first(where: { $0.name.lowercased() == rawValue })!]
            }
        }
    }

}

