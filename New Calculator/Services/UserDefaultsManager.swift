//
//  DataManager.swift
//  New Calculator
//
//  Created by Akbar Jumanazarov on 13/03/25.
//

import Foundation

struct UserDefaultsManagerError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

struct UserDefaultsManager {
    
    private let key = "CALCULATIONS"
    private let ud = UserDefaults.standard

    func getHistory() throws -> [HistoryModels.History] {
        guard let data = ud.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([HistoryModels.History].self, from: data)
        } catch {
            throw UserDefaultsManagerError(message: "Failed to decode: \(error.localizedDescription)")
        }
    }

    func addHistory(_ history: HistoryModels.History) throws {
        var list = try getHistory()
        list.append(history)
        try save(list: list)
    }

    func removeHistory(_ history: HistoryModels.History) throws {
        var list = try getHistory()
        list.removeAll { $0.id == history.id }
        try save(list: list)
    }
    
    func removeHistory(at index: Int) throws {
        var list = try getHistory()
        list.remove(at: index)
        try save(list: list)
    }
    
    func removeHistories(_ histories: [HistoryModels.History]) throws {
        let list = try getHistory()
        
        
        
        try save(list: list)
    }

    func clearHistory() {
        ud.removeObject(forKey: key)
    }

    private func save(list: [HistoryModels.History]) throws {
        do {
            let data = try JSONEncoder().encode(list)
            ud.set(data, forKey: key)
        } catch {
            throw UserDefaultsManagerError(message: "Failed to save: \(error.localizedDescription)")
        }
    }
}
