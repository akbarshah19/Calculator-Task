//
//  HistoryInteractor.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation 

protocol HistoryBusinessLogic {
    func fetchHistory()
    func selectHistory(model: HistoryModels.History)
    func deleteHistory(at indexPath: IndexPath)
    func didPressDone()
    func changeTableEditMode()
    func clearHistory()
}

class HistoryInteractor: HistoryBusinessLogic {
    
    var presenter: HistoryPresentationLogic?
    
    private var userDefaultsManager = UserDefaultsManager()

    func fetchHistory() {
        do {
            let list = try userDefaultsManager.getHistory()
            presenter?.presentTableUpdate(with: list)
        } catch {
            print(error)
        }
    }
    
    func selectHistory(model: HistoryModels.History) {
        presenter?.returnAndDismiss(history: model)
    }
    
    func deleteHistory(at indexPath: IndexPath) {
        do {
            try userDefaultsManager.removeHistory(at: indexPath.row)
            presenter?.deleteAndUpdate(at: indexPath)
        } catch {
            print(error)
        }
    }
    
    func didPressDone() {
        presenter?.dismiss()
    }
    
    func changeTableEditMode() {
        presenter?.changeTableEditMode()
    }
    
    func clearHistory() {
        userDefaultsManager.clearHistory()
        fetchHistory()
    }
}
