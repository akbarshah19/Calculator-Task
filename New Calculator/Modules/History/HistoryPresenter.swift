//
//  HistoryPresenter.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation 

protocol HistoryPresentationLogic {
    func presentFetchedHistory(list: [HistoryModels.History])
    func returnAndDismiss(history: HistoryModels.History)
    func deleteAndUpdate(at indexPath: IndexPath)
    func dismiss()
    func changeTableEditMode()
    func clearHistory()
}

class HistoryPresenter: HistoryPresentationLogic {
    
    weak var viewController: HistoryDisplayLogic?
    
    func presentFetchedHistory(list: [HistoryModels.History]) {
        viewController?.displayFetchedHistory(list: list)
    }
    
    func returnAndDismiss(history: HistoryModels.History) {
        viewController?.returnAndDismiss(history: history)
    }
    
    func deleteAndUpdate(at indexPath: IndexPath) {
        viewController?.deleteAndUpdate(at: indexPath)
    }
    
    func dismiss() {
        viewController?.dismiss()
    }
    
    func changeTableEditMode() {
        
    }
    
    func clearHistory() {
        viewController?.updateTableView()
    }
}
