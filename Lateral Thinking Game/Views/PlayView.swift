//
//  PlayView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 07/03/2025.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isDarkModeOn: Bool
    @State private var isScrolling: Bool = false
    @State private var stories: [Story] = []
    @State private var position: String? = ""
    var sURL: String = "http://localhost:8001"
    
    
    var body: some View {
        NavigationView {
            VStack {
                if !isScrolling{
                    TopBarView(dismiss: _dismiss, toggleButton: $isDarkModeOn)
                }
                
                VStack{
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(stories) { story in
                            NavigationLink{
                                GameView(isDarkModeOn: isDarkModeOn, storyID: story.id)
                            } label: {
                                StoryView(story: story, isDarkModeOn: $isDarkModeOn)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.top, 3)
                    }
                    .scrollPosition(id: $position)
                    .onScrollPhaseChange{ _, newPhase in
                        withAnimation(.default){
                            switch newPhase {
                            case .idle:
                                if position == stories.first?.id {
                                    isScrolling = false
                                }
                            default:
                                isScrolling = true
                            }
                        }
                    }
                }
                
            }
            .background {
                MainBackgroundView()
            }
            
        }
        .onAppear {
            position = stories.first?.id
            isScrolling = false
        }
        .task {
            do {
                stories = try await loadStory()
                if let firstID = stories.first?.id {
                    position = firstID
                }
            } catch SError.invalidURL {
                print("Invalid URL")
            } catch SError.invalidResponse {
                print("Invalid Response")
            } catch SError.invalidData {
                print("Invalid Data")
            } catch {
                print("unexpected error: \(error)")
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .colorScheme(isDarkModeOn ? .dark : .light)
        
    }
    
    func loadStory() async throws -> [Story] {
        let endpoint = "\(sURL)/stories/"

        guard let url = URL(string: endpoint) else {
            throw SError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw SError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            
            return try decoder.decode([Story].self, from: data)
        } catch {
            throw SError.invalidData
        }
        
        
        
    }
    
    
}

struct StoryView: View {
    var story: Story
    @Binding var isDarkModeOn: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.secondarymain)
                .opacity(0.9)
                .shadow(radius: 1)
            
            HStack(){
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(isDarkModeOn ? .black : .white )
                    .opacity(0.7)
                    .frame(maxWidth: 10)
                    .padding()
                
                VStack(){
                    Text(story.title)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .kerning(1)
                    Text(story.situation)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                    
                    
                }
                .foregroundStyle(isDarkModeOn ? .white: .black)
                .multilineTextAlignment(.center)
                .padding(.trailing, 20)
                .lineLimit(4)
                
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 15)
    }
}


#Preview {
    PlayView(isDarkModeOn: .constant(true))
}
