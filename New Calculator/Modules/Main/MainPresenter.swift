//
//  MainPresenter.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import Foundation

protocol MainPresentationLogic {
    func presentOutput(_ output: String)
    func presentResult(result: String, expression: String)
}

class MainPresenter: MainPresentationLogic {
    weak var viewController: MainDisplayLogic?

    func presentOutput(_ output: String) {
        let viewModel = MainModels.OutputViewModel(outputText: output)
        viewController?.displayOutput(viewModel)
    }

    func presentResult(result: String, expression: String) {
        let viewModel = MainModels.ResultViewModel(resultText: result, expressionText: expression)
        viewController?.displayResult(viewModel)
    }
}
