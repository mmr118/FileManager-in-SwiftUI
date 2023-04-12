//
//  String+Extensions.swift
//  FileManager in SwiftUI
//
//  Created by Rondon Monica on 12.04.23.
//

import Foundation

extension String {

    public enum NameParts: String, CaseIterable {
        case first
        case last
        case both
    }

    public static func randomName(_ nameParts: NameParts = .both) -> String {
        return randomNames(count: 1, nameParts: nameParts)[0]
    }

    public static func randomNames(count: Int = 10, nameParts: NameParts = .both) -> [String] {
        let results: [String]
        switch nameParts {
        case .both: results = names.shuffled()
        case .first: results = names.shuffled().compactMap { $0.components(separatedBy: " ") }.map { $0[0] }
        case .last: results = names.shuffled().compactMap { $0.components(separatedBy: " ") }.map { $0[1] }
        }
        
        if count >= results.count {
            return results.shuffled()
        } else {
            return results[0..<count].shuffled()
        }
    }

    // MARK: - Private
    private static let names: [String] = ["Eddie Byrd", "Lena Boone", "Carolina Soto", "Michael Cross", "Kenton Bowman", "Pete Hall", "Sherman Goodwin", "Frankie Eaton", "Dino Cardenas", "Tyree Dawson", "Grant Miranda", "Conrad Charles", "Jonas Hartman", "Kelvin Bryan", "Rusty Macdonald", "Tracey Trevino", "Kristen Frye", "Keneth Freeman", "Rubin Middleton", "Mavis Garner", "Peggy Williamson", "Tonya Chambers", "Cory Cooke", "Austin May", "Jodi Munoz", "Elmer Ellison", "Tami Wise", "Shirley Vance", "Lillie Combs", "Bettye Livingston"]

}
