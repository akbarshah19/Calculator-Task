//
//  MainPresenter.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import Foundation

protocol MainPresentationLogic {
    func presentDisplayUpdate(_ text: String)
    func presentCalculationResult(result: String, expression: String)
    func presentCalculationReset()
}

class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?

    func presentDisplayUpdate(_ text: String) {
        let viewModel = MainModels.DisplayViewModel(displayText: text)
        viewController?.displayUpdate(viewModel)
    }

    func presentCalculationResult(result: String, expression: String) {
        let viewModel = MainModels.CalculationViewModel(result: result, expression: expression)
        viewController?.displayCalculation(viewModel)
    }
    
    func presentCalculationReset() {
        let viewModel = MainModels.CalculationViewModel(result: "0", expression: "")
        viewController?.displayCalculation(viewModel)
    }
}
