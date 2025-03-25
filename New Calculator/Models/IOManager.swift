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
                    return "0,"
                case "-":
                    return "-"
                default:
                    return "0\(input)"
                }
            } else {
                return input
            }
        }
        
        if let lastCharIndex = text.lastIndex(where: { symbols.contains(String($0)) }) {
            let nextIndex = text.index(after: lastCharIndex)
            if nextIndex < text.endIndex {
                let charAfterOperator = text[nextIndex]
                if charAfterOperator == "0" && text.distance(from: nextIndex, to: text.endIndex) == 1 {
                    text.removeLast()
                    text += input
                    return text
                }
            }
        }
        
        // In cases like ')(' puts × inbetween -> ')×('
        if let last = text.last, last == ")", input == "(" {
            text += "×("
            return text
        }
        
        if let last = text.last, symbols.contains(String(last)), symbols.contains(input) {
            text.removeLast()
            text += input
        } else {
            text += input
        }
        
        return text
    }
}
