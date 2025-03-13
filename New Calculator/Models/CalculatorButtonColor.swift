//
//  CalculatorButtonColor.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 12/03/25.
//

import UIKit

enum CalculatorButtonColor {
    case gray
    case orange
    case darkGray
    
    var color: UIColor {
        switch self {
        case .gray:
            UIColor.lightGray.withAlphaComponent(0.5)
        case .orange:
            UIColor.orange
        case .darkGray:
            UIColor.darkGray.withAlphaComponent(0.5)
        }
    }
}
