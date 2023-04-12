//
//  Datum.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 20.01.23.
//

import Foundation

protocol Datum: Codable, Identifiable {
    var id: UUID { get }
    var title: String { get }
}
