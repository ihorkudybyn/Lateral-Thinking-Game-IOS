//
//  GameViewModel.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 19/05/2025.
//

import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    
    @Published var userChat: Chat
    @Published var userMessage: String = ""
    @Published var isHintShown: Bool = false
    @Published var isWaiting: Bool = false
    @Published var submitWindow: Bool = false
    @Published var confettiTrigger: Int = 0
    private final var sURL: String = "http://localhost:8001"
    
    
    @Published private var sessionIDs: SessionIDs
    @Published private(set) var sessionID: String = ""
    private let storyID: String
    
    
    init(storyID: String, sessionIDs: SessionIDs = SessionIDs()) {
        self.storyID = storyID
        self.sessionIDs = sessionIDs
        
        self.userChat = Chat(
            messages: [],
            hintsUsed: 0,
            progressPercent: 0,
            story: Story(id: "", title: "", situation: "", solution: "", keyPoints: [])
        )
        Task {
            await loadCurrentSessionAndChat()
        }
    }
    

    private func loadChat(_ sessionID: String) async throws -> Chat {
        let endpoint = "\(sURL)/conversation/get_chat_by_session/\(sessionID)"
        guard let url = URL(string: endpoint) else { throw SError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { throw SError.invalidResponse }
        return try JSONDecoder().decode(Chat.self, from: data)
    }
    
    private func loadSessionID(_ storyID: String) async throws -> String {
        let endpoint = "\(sURL)/conversation/get_session_id?story_id=\(storyID)"
        guard let url = URL(string: endpoint) else { throw SError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { throw SError.invalidResponse }
        let session = try JSONDecoder().decode(Session.self, from: data)
        return session.sessionId
    }
    

    func loadCurrentSessionAndChat() async {
        do {
            if let existing = sessionIDs.contains(storyID) {
                sessionID = existing.session
            } else {
                sessionID = try await loadSessionID(storyID)
                sessionIDs.items.append(SessionID(id: storyID, session: sessionID))
            }
            let chat = try await loadChat(sessionID)
            var modified = chat
            modified.messages.removeFirst()
            modified.messages.insert(Message(role: "system", content: "You are now playing the puzzle: \(chat.story.title)"), at: 0)
            modified.messages.insert(Message(role: "system", content: chat.story.situation), at: 0)
            userChat = modified
        } catch {
            print("Failed to load session/chat:", error)
        }
    }
    
    func requestHint() {
        guard !isHintShown else {
            withAnimation { isHintShown.toggle() }
            return
        }
        userChat.messages.append(Message(role: "user", content: "Give me a hint!"))
        isWaiting = true
        Task {
            await sendAndReceive(content: "Give me a hint!")
        }
    }
    
    func sendUserMessage() {
        let content = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty, isMeaningful(content) else { return }
        userChat.messages.append(Message(role: "user", content: content))
        userMessage = ""
        isWaiting = true
        Task {
            await sendAndReceive(content: content)
        }
    }
    
    private func sendAndReceive(content: String) async {
        do {
            let updatedChat = try await sendUserMessage(sessionID: sessionID, content: content)
            userChat = updatedChat
            userChat.messages.removeFirst()
            userChat.messages.insert(Message(role: "system", content: "You are now playing the puzzle: \(userChat.story.title)"), at: 0)
            userChat.messages.insert(Message(role: "system", content: userChat.story.situation), at: 0)
        } catch {
            print("Error sending user message:", error)
        }
        isWaiting = false
    }
    
    private func sendUserMessage(sessionID: String, content: String) async throws -> Chat {
        let endpoint = "\(sURL)/conversation/send_user_message"
        guard let url = URL(string: endpoint) else { throw SError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["session_id": sessionID, "message": content])
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else { throw SError.invalidResponse }
        return try JSONDecoder().decode(Chat.self, from: data)
    }
    
    func resetGame() async {
        await deleteChat(sessionID: sessionID)
        await loadCurrentSessionAndChat()
    }
    
    private func deleteChat(sessionID: String) async {
        let endpoint = "\(sURL)/conversation/delete_chat_by_session/\(sessionID)"
        guard let url = URL(string: endpoint) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print("Delete chat responded with status \(http.statusCode)")
            }
        } catch {
            print("Error deleting chat:", error)
        }
    }
    
    private func isMeaningful(_ text: String) -> Bool {
        let letters = CharacterSet.letters
        return text.rangeOfCharacter(from: letters) != nil
    }

}
