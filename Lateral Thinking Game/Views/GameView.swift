//
//  GameView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 14/04/2025.
// 


import SwiftUI
import ConfettiSwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: GameViewModel
    @FocusState private var isFocused: Bool

    private let isDarkModeOn: Bool

    init(isDarkModeOn: Bool, storyID: String) {
        self.isDarkModeOn = isDarkModeOn
        _viewModel = StateObject(wrappedValue: GameViewModel(storyID: storyID))
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    TopBarView(
                        dismiss: _dismiss,
                        toggleButton: $viewModel.submitWindow,
                        imageName: "restart",
                        shadowColor: .clear,
                        alwaysRotate: true
                    )

                    VStack(spacing: 0) {
                        GameProgressView(userChat: $viewModel.userChat)

                        ChatView(
                            userChat: $viewModel.userChat,
                            isFocused: _isFocused,
                            isWaiting: $viewModel.isWaiting
                        )

                        ZStack {
                            Rectangle()
                                .fill(.secondarymain)
                                .shadow(radius: 5)
                            HStack(spacing: 5) {
                                TextField(
                                    "Enter your message...",
                                    text: $viewModel.userMessage
                                )
                                .focused($isFocused)
                                .padding()

                                Button {
                                    viewModel.requestHint()
                                } label: {
                                    HintView(
                                        userChat: $viewModel.userChat,
                                        isHintShown: $viewModel.isHintShown
                                    )
                                }

                                Button {
                                    viewModel.sendUserMessage()
                                } label: {
                                    Image(systemName: "paperplane")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(10)
                                        .foregroundStyle(.text)
                                        .frame(width: 50)
                                }
                                .disabled(
                                    viewModel.userMessage
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                                        .isEmpty
                                )
                            }
                        }
                        .frame(maxHeight: 60)

                        Rectangle()
                            .fill(.secondarymain)
                            .ignoresSafeArea(edges: .bottom)
                            .frame(maxHeight: 1)
                    }
                }
                .background {
                    MainBackgroundView()
                }

                if viewModel.submitWindow {
                    SubmitWindowView(
                        submitWindow: $viewModel.submitWindow,
                        isDarkModeOn: isDarkModeOn,
                        resetGame: viewModel.resetGame,
                        isFocused: _isFocused
                    )
                }

                if viewModel.userChat.progressPercent == 100 {
                    WinningGameView(isFocused: _isFocused, dismiss: _dismiss, userChat: $viewModel.userChat, resetGame: viewModel.resetGame)
                }
            }
            .scrollIndicators(.hidden)
            .colorScheme(isDarkModeOn ? .dark : .light)
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct UserMessage: View {
    var message: Message
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
            }
            
            Text(message.content)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background{
                    RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                        .fill(Color.secondarymain)
                        
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8,
                                       alignment: message.role == "user" ? .trailing : .leading)

            if message.role != "user" {
                Spacer()
            }
        }
        .padding([.leading, .trailing, .top], 3)
    }
}

#Preview {
    GameView(isDarkModeOn: false, storyID: "681a4f110e8e71fd3c656e0e")
}

struct ChatView: View {
    @Binding var userChat: Chat
    @State private var position = ScrollPosition(edge: .bottom)
    @FocusState var isFocused: Bool
    @Binding var isWaiting: Bool
    
    var body: some View {
        ScrollView(){
            ForEach(0..<userChat.messages.count, id: \.self) { i in
                UserMessage(message: userChat.messages[i])
                    .id(i)
            }

            if isWaiting {
                HStack(spacing: 0){
                   TypingAnimationView()
                       .padding(.horizontal, 14)
                       .padding(.vertical, 8)
                       .background{
                           RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                               .fill(Color.secondarymain)
                       }
                       .fixedSize(horizontal: false, vertical: true)
                       .frame(maxWidth: UIScreen.main.bounds.width * 0.8, alignment: .leading)

                   Spacer()
               }
           }
        }
        .padding(.horizontal)
        .padding(.bottom, 3)
        .defaultScrollAnchor(.bottom)
        .scrollPosition($position)
        .onChange(of: userChat.messages.count) {
            withAnimation(.default){
                position.scrollTo(id: userChat.messages.count-1)
            }
        }
        .onChange(of: isWaiting) {
            withAnimation(.default){
                position.scrollTo(id: userChat.messages.count)
            }
        }
        .onTapGesture {
            isFocused = false
        }
        
        
    }
}

struct TypingAnimationView: View {
    
    let textToType = "Typing..."
    private let typingSpeed = 0.2
    private let pauseDuration = 1.0
    @State private var animatedText: String = ""

    var body: some View {
        VStack {
            Text(animatedText)
        }
        .onAppear {
            animateText()
        }
    }

    func animateText() {
        animatedText = ""

        for (index, character) in textToType.enumerated() {
            let delay = Double(index) * typingSpeed
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animatedText.append(character)
            }
        }

        let totalTypingTime = Double(textToType.count) * typingSpeed
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTypingTime + pauseDuration) {
            animateText()
        }
    }
}


struct SubmitWindowView: View {
    @Binding var submitWindow: Bool
    var isDarkModeOn: Bool
    var resetGame: () async -> Void
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(){
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        submitWindow = false
                    }
                }
            
            
            VStack(spacing: 0){
                
                (
                    Text("Are you sure you want to ")
                        .font(.title3)
                    + Text("restart")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                    
                    + Text(" the game?")
                        .font(.title3)
                )
                .foregroundStyle(.text)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                
                Divider()
                    .background(Color.gray)
                
                
                HStack(spacing: 0) {
                    Button(role: .destructive) {
                        Task {
                            await resetGame()
                        }
                        submitWindow = false
                    } label: {
                        Text("Yes")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Divider()
                        .frame(height: 44)
                        .background(Color.gray)
                    
                    Button(role: .cancel) {
                        withAnimation { submitWindow = false }
                    } label: {
                        Text("No")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 44)
                
            }
            .frame(width: 300)
            .scrollContentBackground(.hidden)
            .background(.maincolor)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
        .onAppear() {
            isFocused = false
        }
        
    
    }
}

struct WinningGameView: View {
    @FocusState var isFocused: Bool
    @State private var confettiTrigger: Bool = false
    @Environment(\.dismiss) var dismiss
    @Binding var userChat: Chat
    var resetGame: () async -> Void
    var body: some View {
        ZStack(){
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Text("Congratulations!\n🥳 You won! 🥳")
                    .font(.title3.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Divider()
                
                
                HStack(spacing: 0) {
                    Button(role: .destructive) {
                        Task {
                            await resetGame()
                        }
                        print(userChat.progressPercent)
                    } label: {
                        Text("Restart")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Divider()
                        .frame(height: 44)
                        .background(Color.gray)
                    
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Go to stories")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(height: 44)
                
            }
            .frame(width: 300)
            .scrollContentBackground(.hidden)
            .background(.maincolor)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
        .onAppear {
            confettiTrigger = true
            isFocused = false
        }
        .confettiCannon(trigger: $confettiTrigger, num: 50, rainHeight: 3000, openingAngle: .degrees(0), closingAngle: .degrees(360), radius: 400, repetitions: 3, repetitionInterval: 0.6)
    }
}


struct GameProgressView: View {
    @Binding var userChat: Chat
    
    var body: some View {
        VStack(alignment: .center, spacing: 2){
            Text("Progress: \(userChat.progressPercent, specifier: "%.0f")%")
                .font(.title3.bold())
            ProgressView(value: userChat.progressPercent, total: 100)
                .tint(.blue)
                .progressViewStyle(.linear)
                .padding(.horizontal, 25)
                
        }
        .padding([.top, .bottom], 5)
        .background{
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(.secondarymain)
                .strokeBorder(.text, lineWidth: 1)
                .shadow(radius: 5)
                .frame(maxHeight: 60)
                .padding(.horizontal, 10)
                
        }
    }
}

struct HintView: View {
    @Binding var userChat: Chat
    @Binding var isHintShown: Bool
    
    var body: some View {
        if isHintShown {
            ZStack{
                Circle()
                    .fill(.maincolor)
                    .scaledToFit()
                    .padding(5)
                    .frame(width: 50)

                Text("\(userChat.hintsUsed)")
                    .foregroundStyle(.text)
                    .font(.title)
            }
            .onLongPressGesture {
                withAnimation(.default) {
                    isHintShown.toggle()
                }
            }
        } else {
            Image("hint")
                .resizable()
                .scaledToFit()
                .padding(5)
                .frame(width: 50)
                .onLongPressGesture {
                    withAnimation(.default) {
                        isHintShown.toggle()
                    }
                }
        }
    }
}
