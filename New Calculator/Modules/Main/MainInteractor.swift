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
    private let calculator = MainIOWorker()

    func handleClearButton(displayText: String, gotResult: Bool) {
        calculator.clear(displayText: displayText, gotResult: gotResult) { [weak self] output in
            self?.presenter?.presentDisplayUpdate(output)
        }
    }
    
    func handleClearAllButton() {
        presenter?.presentCalculationReset()
    }

    func handleCalculateButton(expression: String) {
        calculator.calculate(expression: expression) { [weak self] result, expression in
            self?.presenter?.presentCalculationResult(result: result, expression: expression)
        }
    }

    func handleSymbolInput(currentText: String, newSymbol: String) {
        calculator.appendSymbol(labelText: currentText, input: newSymbol) { [weak self] output in
            self?.presenter?.presentDisplayUpdate(output)
        }
    }
    
    func handleHistorySelection(history: HistoryModels.History) {
        presenter?.presentCalculationResult(result: history.answer, expression: history.expression)
    }
}
