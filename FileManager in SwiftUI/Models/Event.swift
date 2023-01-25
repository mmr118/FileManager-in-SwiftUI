//
//  Event.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import Foundation
import SwiftUI
import NMAUtilities

class Event: Datum {
    
    // MARK: - Properties
    var id: UUID
    var title: String
    var detail: String
    var dateCreated: Date
    var crayonRawValue: String
    
    var crayon: CrayonPalette {
        get { CrayonPalette(rawValue: crayonRawValue)! }
        set { crayonRawValue = newValue.rawValue }
    }
    
    required init(id: UUID = UUID(), title: String, detail: String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.dateCreated = Date()
        self.crayonRawValue = CrayonPalette.allCases.randomElement()!.rawValue
    }
    
    convenience init(id: UUID = UUID(), title: String = .randomWord().capitalized, detail: String, crayon: CrayonPalette = CrayonPalette.allCases.randomElement()!, dateCreated: Date = Date()) {
        self.init(id: id, title: title, detail: detail)
        self.dateCreated = dateCreated
        self.crayonRawValue = crayon.rawValue
    }
    
    convenience init(_ title: String, detail: String) {
        self.init(title: title, detail: detail)
    }
    
}
