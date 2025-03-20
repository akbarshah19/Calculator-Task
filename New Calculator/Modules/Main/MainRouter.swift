//
//  MainRouter.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 20/03/25.
//

import UIKit

protocol MainRoutingLogic {
    func routeToHistory(from viewController: MainViewController, callback: @escaping (_ history: History) -> Void)
}

class MainRouter: MainRoutingLogic {
    
    weak var viewController: MainViewController?

    func routeToHistory(from viewController: MainViewController, callback: @escaping (_ history: History) -> Void) {
        let historyVC = HistoryViewController()
        historyVC.didSelect = { history in
            callback(history)
        }

        let navController = UINavigationController(rootViewController: historyVC)
        if let sheet = navController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 20
        }

        viewController.present(navController, animated: true)
    }
}
