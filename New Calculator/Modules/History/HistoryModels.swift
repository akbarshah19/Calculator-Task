//
//  HistoryModels.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation

enum HistoryModels {
    struct History: Identifiable, Codable, Equatable {
        let id: String
        let expression: String
        let answer: String
        let date: Date
    }
}
