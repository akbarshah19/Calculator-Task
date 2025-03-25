//
//  MainViewModel.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 14/03/25.
//

import Foundation

struct MainWorker {
    
    private let userDefaultsManager = UserDefaultsManager()
    private let ioManager = IOManager()
    private let calculator = Calculator()
        
    func calculate(expression: String) -> (result: String, expression: String) {
        let checkedExpression = ioManager.checkLast(expression)
        let result = calculator.calculate(expression: checkedExpression)
        
        if result != expression {
            let history = HistoryModels.History(
                id: UUID().uuidString,
                expression: checkedExpression,
                answer: result,
                date: .now
            )
            try? userDefaultsManager.addHistory(history)
            return (result, checkedExpression)
        }
        return (expression, expression)
    }
    
    func clear(displayText: String, gotResult: Bool) -> String {
        return ioManager.clear(displayText: displayText, gotResult: gotResult)
    }
    
    func appendSymbol(labelText: String, input: String) -> String {
        return ioManager.appendSymbol(labelText: labelText, input: input)
    }
}
