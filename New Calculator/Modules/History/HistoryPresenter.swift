//
//  HistoryPresenter.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation 

protocol HistoryPresentationLogic {
    func presentHistory(_ list: [HistoryModels.History])
    func presentSelectedHistory(_ history: HistoryModels.History)
    func presentDeletedHistory(at indexPath: IndexPath)
    func presentDismiss()
    func presentEditModeChange()
    func presentEmptyHistory()
}

class HistoryPresenter: HistoryPresentationLogic {
    weak var viewController: HistoryDisplayLogic?
    
    func presentHistory(_ list: [HistoryModels.History]) {
        viewController?.displayHistory(list)
    }
    
    func presentSelectedHistory(_ history: HistoryModels.History) {
        viewController?.displaySelectedHistory(history)
    }
    
    func presentDeletedHistory(at indexPath: IndexPath) {
        viewController?.displayDeletedHistory(at: indexPath)
    }
    
    func presentDismiss() {
        viewController?.displayDismiss()
    }
    
    func presentEditModeChange() {
        viewController?.displayEditModeChange()
    }
    
    func presentEmptyHistory() {
        viewController?.displayHistory([])
    }
}
