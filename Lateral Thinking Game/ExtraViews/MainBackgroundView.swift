//
//  MainBackground.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 11/03/2025.
//

import SwiftUI

struct MainBackgroundView: View {
    @State private var rotation: Double = 0.0
    @State private var gridOffset: CGSize = CGSize(width: 188, height: 188)

    var body: some View {
        Grid {
            ForEach(0..<25) { _ in
                GridRow {
                    ForEach(0..<16) { _ in
                        Image("brain")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(rotation))
                            .animation(
                                .linear(duration: 8)
                                    .repeatForever(autoreverses: false),
                                value: rotation
                            )
                    }
                }
            }
        }
        .offset(x: -95, y: -100)
        .offset(gridOffset)
        .animation(
            .linear(duration: 4)
                .repeatForever(autoreverses: false),
            value: gridOffset
        )
        .onAppear {
            gridOffset = CGSize(width: -100, height: -100)
            rotation   = 360
        }
        .drawingGroup()
        .background(Color.maincolor)
    }
}
