//
//  History.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 13/03/25.
//

import Foundation

struct History: Identifiable, Codable {
    let id: String
    let expression: String
    let answer: String
    let date: Date
}
