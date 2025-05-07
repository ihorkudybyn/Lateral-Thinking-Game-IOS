//
//  SettingsView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 03/03/2025.
//

import Foundation

struct Story: Codable, Identifiable {
    let id: String
    let title: String
    let situation: String
    let solution: String
    let keyPoints: [[String : String]]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case situation
        case solution
        case keyPoints = "key_points"
    }
}

struct Session: Codable {
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}

struct Chat: Codable {
    var messages: [Message]
    let hintsUsed: Int
    let progressPercent: Double
    let story: Story
    
    enum CodingKeys: String, CodingKey {
        case messages
        case hintsUsed = "hints_used"
        case progressPercent = "progress_percent"
        case story
    }
}

struct Message: Codable, Hashable {
    let id: UUID = UUID()
    let role: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
    }
}


enum SError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
