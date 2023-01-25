//
//  Note.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

struct Note: Codable, Identifiable, Hashable {
    
    // MARK: - Properties
    var id = UUID()
    var dateCreated = Date()
    let title: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
