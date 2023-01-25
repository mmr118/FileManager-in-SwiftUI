//
//  Datum.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import Foundation


protocol Datum: Codable, Identifiable, Hashable {
    var id: UUID { get }
}

extension Datum { }
