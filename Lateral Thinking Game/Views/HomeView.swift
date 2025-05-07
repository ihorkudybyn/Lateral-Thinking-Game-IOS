//
//  ContentView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 18/02/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var offsets: [CGFloat] = [-200, -300, -500, -600]
    
    @State private var actionButtonRotationToggle = false
    
    
    @State private var isDarkModeOn = false
    @State private var settingsPresenter = true
    @State private var navigateToPlay = false
    
    @State private var goToPlay = false
    @State private var goToRules = false
       
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack() {
                        AdditionalButtonView(toggleButton: $isDarkModeOn, imageName: "lightbulb", shadowColor: .lightbulbcolor)
                            .offsetAnimation($offsets[1])
                        
                        Spacer()
                        
                        SubTitleView()
                            .offsetAnimation($offsets[0])
                        
                        Spacer()
                        
                        AdditionalButtonView(toggleButton: $settingsPresenter, imageName: "settings", shadowColor: .gray)
                            .offsetAnimation($offsets[1])
                            .onTapGesture {
                                settingsPresenter.toggle()
                            }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                        
                    LogoView()
                        .offsetAnimation($offsets[1])
                    
                    Spacer()
                    

                    Button() {
                        goToPlay = true
                    } label: {
                        ActionButtonView(text: "Play", foregroundColor: .play)
                    }
                    .navigationDestination(isPresented: $goToPlay) {
                        PlayView(isDarkModeOn: $isDarkModeOn)
                    }
                    .offsetAnimation($offsets[2])
                        
                    
                    
                    Button() {
                        goToRules = true
                    } label: {
                        ActionButtonView(text: "Rules", foregroundColor: .rules)
                    }
                    .offsetAnimation($offsets[3])
                    
                    
                    
                    
                    Spacer()
                    
                }
                
                if goToRules {
                    ZStack(){
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    goToRules = false
                                }
                                
                            }
                        
                        VStack(spacing: 0){
                            HStack(alignment: .center, spacing: 0){
                                Spacer()
                                Spacer()
                                Spacer()
                                Text("How to Play?")
                                    .font(.title3.bold())
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.center)
                                    .padding([.top, .horizontal])
                                Spacer()
                                Button(){
                                    goToRules = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundStyle(.text)
                                        .frame(width: 20, height: 20)
                                        .padding([.top, .horizontal])
                                    
                                }
                            }
                            
                            Text("The \"Lateral Thinking Game\" is an interactive web application that challenges users to solve puzzles based on lateral thinking. Players uncover the story behind each puzzle by asking a series of \"yes\" or \"no\" questions. Using a language model, the app analyzes the users' questions and provides answers, gradually guiding them toward the key clues needed to solve the puzzle.")
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .frame(width: 300)
                        .scrollContentBackground(.hidden)
                        .background(.maincolor)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                }
                
                
                if settingsPresenter {
                    SettingsView(isDarkModeOn: $isDarkModeOn, settingsPresenter: $settingsPresenter)
                }
                
            }
            .background{
                MainBackgroundView()
            }
            
        }
        .colorSchemeModifier($isDarkModeOn)
        .ignoresSafeArea()

    }
}


#Preview {
    HomeView()
}

/// Modifiers Zone

struct ColorSchemeModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDarkModeOn: Bool
    @State var hasAppeared: Bool = false
    
    func body(content: Content) -> some View {
        content
            .colorScheme(isDarkModeOn ? .dark : .light)
            .onAppear() {
                
                if !hasAppeared {
                    hasAppeared = true
                    isDarkModeOn = (colorScheme == .dark)
                }
            }
    }
}

struct OffsetAnimation: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 100, damping: 5)) {
                    offset = 0
                }
            }
    }
}

extension View {
    func colorSchemeModifier(_ isDarkModeOn: Binding<Bool>) -> some View {
        self.modifier(ColorSchemeModifier(isDarkModeOn: isDarkModeOn))
    }
    
    func offsetAnimation(_ offset: Binding<CGFloat>) -> some View {
        self.modifier(OffsetAnimation(offset: offset))
    }
}


/// Views Zone


struct LogoView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)).fill(.secondarymain)
                .shadow(radius: 5)
                .frame(maxWidth: 300 ,maxHeight: 200)
            VStack{
                Text("Lateral")
                Text("Thinking")
                Text("Game")
            }
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .kerning(3)
        }
    }
}


struct ActionButtonView: View {
    let text: String
    let foregroundColor: Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 30, height: 30)).fill(.secondarymain)
                .shadow(radius: 1)
                .frame(maxWidth: 170 ,maxHeight: 95)
                
            Text(text)
                .foregroundStyle(foregroundColor)
                .font(.system(size: 55, weight: .bold, design: .rounded))
                .kerning(3)
            
        }
    }
}
