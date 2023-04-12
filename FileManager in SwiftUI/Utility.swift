//
//  Utility.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation


struct FFL {
    struct OutputOptions: OptionSet {
        let rawValue: Int
        static let file = Self(rawValue: 1 << 0)
        static let function = Self(rawValue: 1 << 1)
        static let line = Self(rawValue: 1 << 2)
        static let all: Self = [.file, .function, .line]
        static let fuLine: Self = [.function, .line]
    }

    static var options: OutputOptions = .fuLine

    let file: String
    let function: String
    let line: Int
    let trimmedFilename: String
    var description: String { configuredDescription(Self.options) }
    init(_ file: String, _ function: String, _ line: Int) {
        self.file = file
        self.function = function
        self.line = line
        self.trimmedFilename = String(describing: file).components(separatedBy: "/").last ?? file
    }

    func configuredDescription(_ options: OutputOptions = Self.options) -> String {
        var result = String()

        if options.contains(.file) {
            result.append(trimmedFilename)
        }

        if options.contains(.function) {
            result.isEmpty ? result.append(function) : result.append(".\(function)")
        }

        if options.contains(.line) {
            result.isEmpty ? result.append("#\(line)") : result.append(" #\(line)")
        }
        return result
    }
}


public func printFFL(_ values: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    let ffl = FFL(file, function, line)
    print(ffl.description, terminator: " ")
    print(values)
}
