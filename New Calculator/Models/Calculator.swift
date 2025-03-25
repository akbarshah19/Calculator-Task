//
//  Calculator.swift
//  Calculator-Task
//
//  Created by Akbar Jumanazarov on 04/03/25.
//

import Foundation

private enum EvaluationResult {
    case success(Double)
    case divisionByZero
    case invalidExpression
}

struct Calculator {
    
    func calculate(expression: String) -> String {
        let refined = expression.replacingOccurrences(of: ",", with: ".")
        let balanced = balanceParentheses(in: refined)
        let tokens = tokenize(balanced)
        let postfix = infixToPostfix(tokens)
        
        let evaluationResult = evaluatePostfix(postfix)
        
        switch evaluationResult {
        case .success(let result):
            let formatted = String(format: "%.10f", result)
                .replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
                .replacingOccurrences(of: ".", with: ",")
            return formatted
        case .divisionByZero:
            return "Undefined"
        case .invalidExpression:
            return expression
        }
    }
    
    private func balanceParentheses(in expression: String) -> String {
        var openCount = 0
        var closeCount = 0
        
        for char in expression {
            if char == "(" { openCount += 1 }
            if char == ")" { closeCount += 1 }
        }
        
        let missingClosings = max(0, openCount - closeCount)
        return expression + String(repeating: ")", count: missingClosings)
    }
    
    private func precedence(of op: String) -> Int {
        switch op {
            case "+", "-": return 1
            case "×", "÷": return 2
            default: return 0
        }
    }

    private func tokenize(_ expression: String) -> [String] {
        var tokens: [String] = []
        var number = ""
        var prevChar: Character?

        let characters = Array(expression)
        var i = 0

        while i < characters.count {
            let char = characters[i]

            if char.isNumber || char == "." {
                number.append(char)
            } else {
                if !number.isEmpty {
                    tokens.append(number)
                    number = ""
                }

                if char == "(" {
                    // Implicit multiplication before '('
                    if let prev = prevChar, prev.isNumber || prev == ")" {
                        tokens.append("×")
                    }
                    tokens.append(String(char))
                } else if char == ")" {
                    tokens.append(String(char))
                    // Implicit multiplication after ')'
                    if i + 1 < characters.count {
                        let next = characters[i + 1]
                        if next.isNumber || next == "(" {
                            tokens.append("×")
                        }
                    }
                } else if char == "-" {
                    if prevChar == nil || "+-×÷(".contains(prevChar!) {
                        number.append(char) // negative number
                    } else {
                        tokens.append(String(char))
                    }
                } else if "+×÷".contains(char) {
                    tokens.append(String(char))
                }
            }

            if char != " " {
                prevChar = char
            }
            i += 1
        }

        if !number.isEmpty {
            tokens.append(number)
        }

        return tokens
    }
    
    private func infixToPostfix(_ tokens: [String]) -> [String] {
        var output: [String] = []
        var operators: [String] = []

        for token in tokens {
            if Double(token) != nil {
                output.append(token)
            } else if token == "(" {
                operators.append(token)
            } else if token == ")" {
                while let last = operators.last, last != "(" {
                    output.append(operators.removeLast())
                }
                if operators.last == "(" {
                    operators.removeLast()
                }
            } else {
                while let last = operators.last, precedence(of: last) >= precedence(of: token) {
                    output.append(operators.removeLast())
                }
                operators.append(token)
            }
        }

        while !operators.isEmpty {
            output.append(operators.removeLast())
        }
        return output
    }

    private func evaluatePostfix(_ tokens: [String]) -> EvaluationResult {
        var stack: [Double] = []

        for token in tokens {
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else {
                    return .invalidExpression
                }
                let operand2 = stack.removeLast()
                let operand1 = stack.removeLast()
                
                switch token {
                case "+":
                    stack.append(operand1 + operand2)
                case "-":
                    stack.append(operand1 - operand2)
                case "×":
                    stack.append(operand1 * operand2)
                case "÷":
                    if operand2 == 0 {
                        return .divisionByZero
                    }
                    stack.append(operand1 / operand2)
                default:
                    return .invalidExpression
                }
            }
        }

        if stack.count == 1 {
            return .success(stack[0])
        } else {
            return .invalidExpression
        }
    }
}
