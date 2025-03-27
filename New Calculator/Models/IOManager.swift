//
//  IOManager.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/25/25.
//

import Foundation

struct IOManager {
    
    func checkLast(_ expression: String) -> String {
        var expr = expression
        let symbols = ["+", "−", "×", "÷", "(", "."]
        if let last = expr.last, symbols.contains(String(last)) {
            expr.removeLast()
        }
        return expr
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
    
    func appendSymbol(labelText: String, input: String) -> String {
        var text: String = labelText
        let symbols = ["+", "×", "÷", "-", ","]
        
        if text == "0" {
            if input == "00" {
                return text
            }
            
            if symbols.contains(input) {
                switch input {
                case ",":
                    return "0," // Allow "0," as the first number
                case "-":
                    return "-"  // Allow "-" at start
                default:
                    return "0\(input)"
                }
            } else {
                return input
            }
        }
        
        // Count the number of open "(" and close ")" parentheses
        let openCount = text.filter { $0 == "(" }.count
        let closeCount = text.filter { $0 == ")" }.count
        
        // Prevent ")" as the first character
        if text.isEmpty && input == ")" {
            return text
        }
        
        // Prevent ")" if there isn't an unmatched "("
        if input == ")" && closeCount >= openCount {
            return text
        }
        
        // Prevent operators (except "-") right after "("
        if let last = text.last, last == "(", symbols.contains(input), input != "-" {
            return text
        }
        
        // Prevent multiple consecutive "-"
        if text.count >= 2, let last = text.last, last == "-", symbols.contains(input) {
            return text
        }
        
        // Prevent multiple commas in a single number (improved version)
        if input == "," {
            if let lastPart = extractCurrentNumber(from: text), lastPart.contains(",") {
                return text // Ignore additional commas
            }
            
            if let last = text.last, symbols.contains(String(last)) {
                return text // Ignore comma right after an operator
            }
        }
        
        // Automatically add multiplication before "(" if preceded by a number or ")"
        if input == "(" {
            if let last = text.last, last.isNumber || last == ")" {
                text += "×"
            }
        }
        
        // If ")" is followed by "(", insert × between them: ")("
        if let last = text.last, last == ")", input == "(" {
            text += "×("
            return text
        }
        
        // If an operator is followed by ")", remove the operator and insert ")"
        if let last = text.last, symbols.contains(String(last)), input == ")" {
            text.removeLast()
        }
        
        // If the last character is an operator and another operator is entered, replace the last one
        if let last = text.last, symbols.contains(String(last)), symbols.contains(input) {
            text.removeLast()
            text += input
        } else {
            text += input
        }
        
        return text
    }
    
    private func extractCurrentNumber(from expression: String) -> String? {
        var currentNumber = ""
        
        for char in expression.reversed() {
            if char.isNumber || char == "," {
                currentNumber.append(char)
            } else {
                break
            }
        }
        print(String(currentNumber.reversed()))
        return String(currentNumber.reversed())
    }
}
