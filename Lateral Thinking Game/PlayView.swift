//
//  PlayView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 07/03/2025.
//

import SwiftUI
import UIKit

struct PlayView: View {
    @Environment(\.dismiss) var dismiss 
    @State var isDarkModeOn: Bool = true
    @State private var stories: [Story] = []
    @State private var toolbarVisible: Visibility = .visible

    
    var body: some View {
        NavigationView() {
            ScrollView() {
                ForEach(stories) { story in
                    StoryView(story: story, isDarkModeOn: $isDarkModeOn)
                }
                .task {
                    do {
                        stories = try await loadStory()
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
            }
            .padding(.top, 10)
            .scrollIndicators(.hidden)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    BackButtonView(imageName: "lightbulb")
                        .border(.red)
                }
                
            }
            
            .background{
                MainBackgroundView()
                    .background(Color(.maincolor))
            }
            
        }
        
        .navigationBarBackButtonHidden(false)
        .colorScheme(isDarkModeOn ? .dark : .light)
        
        
        
    }
    
    func loadStory() async throws -> [Story] {
        let endpoint = "http://localhost:8001/stories/"
        
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

#Preview {
    PlayView()
}

struct BackButtonView: View {
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle().fill(.secondarymain)
                .shadow(radius: 3)
                .frame(height: 50)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 40)
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
                .shadow(radius: 5)
                
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
                .multilineTextAlignment(.center)
                .padding(.trailing, 20)
                .lineLimit(4)
                
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 15)
    }
}
