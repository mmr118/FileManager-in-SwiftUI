//
//  Datum.swift
//  FileManager Example
//
//  Created by Monica Rondón on 25.01.23.
//

import Foundation


protocol Datum: Codable, Identifiable, Hashable, Equatable {
    var id: UUID { get }
    var title: String { get set }
    var detail: String { get set }
    
    init(id: UUID, title: String, detail: String)
}

extension Datum {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: DatumCodingKeys.self)
//        let id = try container.decode(UUID.self, forKey: .id)
//        let title = try container.decode(String.self, forKey: .title)
//        let detail = try container.decode(String.self, forKey: .detail)
//        self.init(id: id, title: title, detail: detail)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: DatumCodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(title, forKey: .title)
//        try container.encode(detail, forKey: .detail)
//    }

//enum DatumCodingKeys: CodingKey {
//    case id, title, detail
//}
