//
//  MainInteractor.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import Foundation

protocol MainBusinessLogic {
    func handleClearButton(displayText: String, gotResult: Bool)
    func handleClearAllButton()
    func handleCalculateButton(expression: String)
    func handleSymbolInput(currentText: String, newSymbol: String)
    func handleHistorySelection(history: HistoryModels.History)
}

class MainInteractor: MainBusinessLogic {
    
    var presenter: MainPresentationLogic?
    private let calculator = MainWorker()

    func handleClearButton(displayText: String, gotResult: Bool) {
        let output = calculator.clear(displayText: displayText, gotResult: gotResult)
        presenter?.presentDisplayUpdate(output)
    }
    
    func handleClearAllButton() {
        presenter?.presentCalculationReset()
    }

    func handleCalculateButton(expression: String) {
        let (result, expression) = calculator.calculate(expression: expression)
        presenter?.presentCalculationResult(result: result, expression: expression)
    }

    func handleSymbolInput(currentText: String, newSymbol: String) {
        let output = calculator.appendSymbol(labelText: currentText, input: newSymbol)
        presenter?.presentDisplayUpdate(output)
    }
    
    func handleHistorySelection(history: HistoryModels.History) {
        presenter?.presentCalculationResult(result: history.answer, expression: history.expression)
    }
}
