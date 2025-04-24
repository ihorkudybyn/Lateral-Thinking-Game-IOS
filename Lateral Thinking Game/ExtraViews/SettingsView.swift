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

            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        settingsPresenter = false
                    }
                }
                

            Form {
                Section("Appearance mode") {
                    Toggle("Dark mode", isOn: $isDarkModeOn.animation())
                        .listRowBackground(Color.secondarymain)
                        .tint(.blue)
                }
            }
            .frame(width: 300, height: 200)
            .scrollContentBackground(.hidden)
            .background(.maincolor)
            .cornerRadius(15)
            .shadow(radius: 10)
            
    }
}
