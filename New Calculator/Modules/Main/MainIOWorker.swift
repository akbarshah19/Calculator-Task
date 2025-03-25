//
//  MainViewModel.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 14/03/25.
//

import Foundation

class MainIOWorker {
    
    private let userDefaultsManager = UserDefaultsManager()
    private let calculator = Calculator()
    
    var buttons: [CalculatorButton] = Constants.portraitButtons
    
    func calculate(expression: String, completion: (_ result: String, _ expression: String) -> Void) {
        var expr = expression
        let symbols = ["+", "−", "×", "÷", "(", "."]
        if let last = expr.last, symbols.contains(String(last)) {
            expr.removeLast()
        }
        
        let result = calculator.calculate(expression: expr)
        
        if result != expression {
            let history = HistoryModels.History(id: UUID().uuidString, expression: expr, answer: result, date: .now)
            completion(result, expr)
            try? userDefaultsManager.addHistory(history)
        }
    }
    
    func clear(displayText: String, gotResult: Bool, completion: (_ output: String) -> Void) {
        if gotResult || displayText == "Undefined" {
            completion("0")
        } else if displayText.count <= 1 {
            completion("0")
        } else {
            var updated = displayText
            updated.removeLast()
            completion(updated)
        }
    }
    
    func appendSymbol(labelText: String, input: String, completion: (_ output: String) -> Void) {
        
        var text: String = labelText
        let symbols = ["+", "×", "÷", "-", ","]
        
        if text == "0" {
            if input == "00" {
                return
            }
            
            if symbols.contains(input) {
                switch input {
                case ",":
                    completion("0,")
                    return
                case "-":
                    completion("-")
                    return
                default:
                    completion("0\(input)")
                    return
                }
            } else {
                completion(input)
                return
            }
        }
        
        if let lastCharIndex = text.lastIndex(where: { symbols.contains(String($0)) }) {
            let nextIndex = text.index(after: lastCharIndex)
            if nextIndex < text.endIndex {
                let charAfterOperator = text[nextIndex]
                if charAfterOperator == "0" && text.distance(from: nextIndex, to: text.endIndex) == 1 {
                    // Only remove the 0 if it's the last character after an operator
                    text.removeLast()
                    text += input
                    completion(text)
                    return
                }
            }
        }
        
        //Replacing the last operator with new one e.g. "+-" -> "-"
        if let last = text.last, symbols.contains(String(last)), symbols.contains(input) {
            text.removeLast()
            text += input
        } else {
            text += input
        }
        
        completion(text)
    }
}
