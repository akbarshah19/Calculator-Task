//
//  MainModels.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import Foundation

enum MainModels {
    struct DisplayViewModel {
        let displayText: String
    }

    struct CalculationViewModel {
        let result: String
        let expression: String
    }
    
    struct HistoryViewModel {
        let result: String
        let expression: String
    }
}
