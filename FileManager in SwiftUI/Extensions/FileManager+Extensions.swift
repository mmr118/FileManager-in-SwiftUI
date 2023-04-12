//
//  FileManager+Extensions.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation

extension FileManager {

    var documentsDir: URL { urls(for: .documentDirectory, in: .userDomainMask)[0] }
    
}
