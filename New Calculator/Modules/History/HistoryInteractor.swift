//
//  HistoryInteractor.swift
//  New Calculator
//
//  Created by Akbarshah Jumanazarov on 3/23/25.
//

import Foundation 

protocol HistoryBusinessLogic {
    func fetchHistory()
    func selectHistoryItem(model: HistoryModels.History) // Renamed for clarity
    func deleteHistoryItem(at indexPath: IndexPath) // Renamed for clarity
    func handleDoneButtonTapped() // Renamed for clarity
    func toggleEditMode() // Renamed for clarity
    func clearAllHistory() // Renamed for clarity
}

class HistoryInteractor: HistoryBusinessLogic {
    var presenter: HistoryPresentationLogic?
    private var userDefaultsManager = UserDefaultsManager()

    func fetchHistory() {
        do {
            let list = try userDefaultsManager.getHistory()
            presenter?.presentHistory(list) // We'll rename this in presenter
        } catch {
            print(error)
        }
    }
    
    func selectHistoryItem(model: HistoryModels.History) {
        presenter?.presentSelectedHistory(model) // We'll rename this in presenter
    }
    
    func deleteHistoryItem(at indexPath: IndexPath) {
        do {
            try userDefaultsManager.removeHistory(at: indexPath.row)
            presenter?.presentDeletedHistory(at: indexPath)
        } catch {
            print(error)
        }
    }
    
    func handleDoneButtonTapped() {
        presenter?.presentDismiss()
    }
    
    func toggleEditMode() {
        presenter?.presentEditModeChange()
    }
    
    func clearAllHistory() {
        userDefaultsManager.clearHistory()
        fetchHistory()
    }
}
