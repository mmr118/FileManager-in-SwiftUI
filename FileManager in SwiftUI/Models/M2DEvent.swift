//
//  M2DEvent.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 20.01.23.
//

import Foundation

struct M2DEvent: Datum {

    // MARK: - Properties
    var id = UUID()
    var dateCreate = Date()
    var title: String

    init(_ title: String) {
        self.title = title
    }

}
