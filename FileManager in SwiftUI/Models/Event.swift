//
//  Event.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import Foundation
import SwiftUI
import NMAUtilities

struct Event: Datum {
    
    // MARK: - Properties
    var id = UUID()
    var dateCreated = Date()
    let title: String
    let detail: String
    var crayonRawValue: String
    var crayon: CrayonPalette {
        get { CrayonPalette(rawValue: crayonRawValue)! }
        set { crayonRawValue = newValue.rawValue }
    }

    init(id: UUID = UUID(), dateCreated: Date = Date(), title: String = .randomWord().capitalized, detail: String, crayon: CrayonPalette = CrayonPalette.allCases.randomElement()!) {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.detail = detail
        self.crayonRawValue = crayon.rawValue
    }
    
    init(_ title: String, detail: String) {
        self.init(title: title, detail: detail)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
