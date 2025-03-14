//
//  MainViewModel.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 14/03/25.
//

import Foundation

class MainViewModel {
    
    private let userDefaultsManager = UserDefaultsManager()
    private let calculator = Calculator()

    var buttons: [CalculatorButton] = Constants.portraitButtons
    
    var onDisplayUpdate: ((String, String) -> Void)?
    
    func calculate(expression: String) {
        var expr = expression
        let symbols = ["+", "−", "×", "÷", "(", "."]
        if let last = expr.last, symbols.contains(String(last)) {
            expr.removeLast()
        }

        let result = calculator.calculate(expression: expr)
        onDisplayUpdate?(result, expr)
        
        if result != expression {
            let history = History(id: UUID().uuidString, expression: expr, answer: result, date: .now)
            try? userDefaultsManager.addHistory(history)
        }
    }
    
    func clear(displayText: String, gotResult: Bool) -> String {
        if gotResult || displayText == "Undefined" {
            return "0"
        } else if displayText.count <= 1 {
            return "0"
        } else {
            var updated = displayText
            updated.removeLast()
            return updated
        }
    }
    
    func appendSymbol(currentText: String, symbol: String) -> String {
        var text = currentText
        if text == "0" {
            let symbols = ["+", "×", "÷", "-", ",", "(", ")"]
            if symbols.contains(symbol) {
                switch symbol {
                case ",": return "0,"
                case "-": return "-"
                default: return "0\(symbol)"
                }
            } else {
                return symbol
            }
        }

        let symbols = ["+", "×", "÷", "-", ","]
        if let last = text.last,
           symbols.contains(String(last)),
           symbols.contains(symbol) {
            text.removeLast()
            text += symbol
        } else {
            text += symbol
        }
        return text
    }
}
