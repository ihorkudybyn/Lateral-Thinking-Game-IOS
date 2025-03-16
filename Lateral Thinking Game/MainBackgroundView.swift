//
//  MainBackground.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 11/03/2025.
//

import SwiftUI

struct MainBackgroundView: View {
    @State private var rotation: Double = 0.0
    @State private var gridOffset: CGSize = CGSize(width: 283, height: 283)

    var body: some View {
        Grid {
            ForEach(0..<31) { _ in
                GridRow {
                    ForEach(0..<21) { _ in
                        Image("brain")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(rotation))
                    }
                }
            }
        }
        .offset(gridOffset)
        .onAppear {
            withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: false)) {
                gridOffset = CGSize(width: -100, height: -100)
                rotation = 360
            }
        }
        .drawingGroup()
        .ignoresSafeArea()
    }
}
