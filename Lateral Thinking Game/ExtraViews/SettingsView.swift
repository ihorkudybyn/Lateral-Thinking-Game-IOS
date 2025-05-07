//
//  SettingsView.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 28/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isDarkModeOn: Bool
    @Binding var settingsPresenter: Bool
    @State private var animateTransition = false
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        settingsPresenter = false
                    }
                }
                    
            VStack(spacing: 0){
                HStack(spacing: 0){
                    Spacer()
                    Spacer()
                    Text("Settings")
                        .font(.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding([.top, .horizontal])
                    Spacer()
                    Button(){
                        settingsPresenter = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundStyle(.text)
                            .frame(width: 20, height: 20)
                            .padding([.top, .horizontal])
                    }
                }

                Form {
                    Section("Appearance mode") {
                        Toggle("Dark mode", isOn: $isDarkModeOn.animation())
                            .listRowBackground(Color.secondarymain)
                            .tint(.blue)
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            .frame(width: 300, height: 200)
            .background(.maincolor)
            .cornerRadius(15)
            .shadow(radius: 10)
                
        }
    }
}
