//
//  Encodable.swift
//  FitUp
//
//  Created by Kamal Abdullayev on 08.04.25.
//

import Foundation
extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        return json ?? [:]
    }
}
