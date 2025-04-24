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
    @State private var settingsPresenter = false
    @State private var navigateToPlay = false
    
       
    
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
                    
                    NavigationLink {
                        PlayView()
                    } label: {
                        ActionButtonView(text: "Play", foregroundColor: .play)
                            .offsetAnimation($offsets[2])
                    }
                    
                    
                    NavigationLink {
//                        PlayView()
                    } label: {
                        ActionButtonView(text: "Rules", foregroundColor: .rules)
                            .offsetAnimation($offsets[3])
                    }
                    
                    
                    Spacer()
                    
                }
                .background{
                    MainBackgroundView()
                        .background(Color(.maincolor))
                }
                
                if settingsPresenter {
                    SettingsView(isDarkModeOn: $isDarkModeOn, settingsPresenter: $settingsPresenter)
                }
                
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




struct AdditionalButtonView: View {
    
    @Binding var toggleButton: Bool
    var imageName: String
    var shadowColor: Color
    
    var body: some View {
        Button() {
            toggleButton.toggle()
        } label: {
            ZStack{
                Circle().fill(.secondarymain)
                    .shadow(radius: 3)
                    .frame(maxHeight: 65)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: shadowColor, radius: 10)
                    .shadow(color: shadowColor ,radius: 3)
                    .rotationEffect(.degrees(toggleButton ? 180 : 360))
                    .frame(maxHeight: 40)
            }
                
        }
    }
}

struct SubTitleView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)).fill(.secondarymain)
                .shadow(radius: 5)
                .frame(maxWidth: 140 ,maxHeight: 65)
                
            Text("LTG")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .kerning(3)
        }
    }
}


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
