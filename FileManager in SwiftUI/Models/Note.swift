//
//  Note.swift
//  FileManager in SwiftUI
//
//  Created by Can Balkaya on 2/25/21.
//

import Foundation

struct Note: Datum {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let description: String
}
