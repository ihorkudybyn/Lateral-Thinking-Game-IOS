//
//  TopBarViews.swift
//  Lateral Thinking Game
//
//  Created by Ihor Kudybyn on 24/04/2025.
//

import SwiftUI

struct TopBarView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var toggleButton: Bool
    var imageName: String = "lightbulb"
    var shadowColor: Color = .lightbulbcolor
    var alwaysRotate: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                dismiss()
            } label: {
                BackButtonView(imageName: "backbutton")
            }
            
            Spacer()
            
            SubTitleView()
            
            Spacer()
            
            AdditionalButtonView(toggleButton: $toggleButton, imageName: imageName, shadowColor: shadowColor, alwaysRotate: alwaysRotate)
            
        }
        .padding(.horizontal, 20)
        .frame(height: 70)
    }
}

struct AdditionalButtonView: View {
    
    @Binding var toggleButton: Bool
    var imageName: String
    var shadowColor: Color
    var alwaysRotate: Bool = false
        
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button() {
            withAnimation(.default){
                toggleButton.toggle()
            }
            rotationAngle += 360
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
                    .rotationEffect(.degrees(alwaysRotate ? rotationAngle : (toggleButton ? 180 : 360)))
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


struct BackButtonView: View {
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle().fill(.secondarymain)
                .shadow(radius: 3)
                .frame(height: 60)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 40)
        }
        
    }
}
