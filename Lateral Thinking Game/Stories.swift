//
//  SettingsView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 03/03/2025.
//



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


enum SError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
