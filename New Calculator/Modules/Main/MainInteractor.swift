//
//  MainInteractor.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import Foundation

protocol MainBusinessLogic {
    func clear(displayText: String, gotResult: Bool)
    func clearAll()
    func calculate(expression: String)
    func appendSymbol(labelText: String, input: String)
    func displaySelectedHistory(history: HistoryModels.History)
}

class MainInteractor: MainBusinessLogic {
    
    var presenter: MainPresentationLogic?
    private let viewModel = MainIOWorker()

    func clear(displayText: String, gotResult: Bool) {
        viewModel.clear(displayText: displayText, gotResult: gotResult) { [weak self] output in
            self?.presenter?.presentOutput(output)
        }
    }
    
    func clearAll() {
        presenter?.presentResult(result: "0", expression: "")
    }

    func calculate(expression: String) {
        viewModel.calculate(expression: expression) { [weak self] result, expression in
            self?.presenter?.presentResult(result: result, expression: expression)
        }
    }

    func appendSymbol(labelText: String, input: String) {
        viewModel.appendSymbol(labelText: labelText, input: input) { [weak self] output in
            self?.presenter?.presentOutput(output)
        }
    }
    
    func displaySelectedHistory(history: HistoryModels.History) {
        presenter?.presentResult(result: history.answer, expression: history.expression)
    }
}
