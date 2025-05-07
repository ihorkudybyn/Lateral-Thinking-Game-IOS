//
//  Session.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 24/04/2025.
//

import Foundation
import SwiftData


class SessionID: Identifiable, Codable {
    var id: String
    var session: String
    
    init(id: String, session: String) {
        self.id = id
        self.session = session
    }
}


class SessionIDs: ObservableObject {
    @Published var items = [SessionID]() {
        didSet {

            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    func contains(_ item: String) -> SessionID? {
        for i in items {
            if i.id == item {
                return i
            }
        }
        return nil
    }
    
    func removeSession(_ session: String) {
        for (index, item) in items.enumerated() {
            if item.session == session {
                items.remove(at: index)
                return
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([SessionID].self, from: savedItems) {
                items = decoded
                return
            }
        }
        
        items = []
        
    }
    
}
