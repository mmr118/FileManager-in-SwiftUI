//
//  Note.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

class Note: Datum {
    
    // MARK: - Properties
    var id: UUID
    var title: String
    var detail: String
    var dateCreated: Date

    required init(id: UUID = UUID(), title: String, detail: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.dateCreated = Date()
    }
    
    convenience init(id: UUID = UUID(), title: String, detail: String, dateCreated: Date) {
        self.init(id: id, title: title, detail: detail)
        self.dateCreated = dateCreated
    }
    
    convenience init(_ title: String, detail: String) {
        self.init(title: title, detail: detail)
    }
    
}
