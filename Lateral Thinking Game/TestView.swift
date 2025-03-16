import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                Text("Hello")
            } label: {
                RotatingActionButton(text: "Play", foregroundColor: .white)
            }
        }
    }
}

struct RotatingActionButton: View {
    @Environment(\.dismiss) var dismiss
    @State private var rotationT = false
    let text: String
    let foregroundColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(.secondary) // Use your desired color
                .shadow(radius: 1)
                .frame(maxWidth: 140, maxHeight: 65)
            Text(text)
                .foregroundStyle(foregroundColor)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .kerning(3)
        }
        .rotationEffect(.degrees(rotationT ? 360 : 0))
        .onTapGesture {
            withAnimation(.linear(duration: 1)) {
                rotationT.toggle()
            }
        }
        .navigationDestination(isPresented: $rotationT) {
            
            Text("Hello")
        }
    }
}


#Preview {
    TestView()
}
