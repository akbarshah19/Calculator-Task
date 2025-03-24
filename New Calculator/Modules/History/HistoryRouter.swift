//
//  HistoryRouter.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation 

protocol HistoryRoutingLogic {
    func dismiss()
}

class HistoryRouter: HistoryRoutingLogic {
    
    weak var viewController: HistoryViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
