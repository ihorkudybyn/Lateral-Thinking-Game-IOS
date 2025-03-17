//import SwiftUI
//
//struct ScrollPositionModifier: View {
//    @State private var scrollViewPosition: Int? = 0
//    var body: some View {
//        VStack {
//            ScrollView {
//                VStack{
//                    ForEach(0..<100, id: \.self) { num in
//                        Rectangle()
//                            .fill(Color.green.opacity(0.5))
//                            .frame(height: 100)
//                            .cornerRadius(10)
//                            .padding()
//                            .overlay {
//                                Text(verbatim: num.formatted())
//                                    .font(.system(size: 18,weight: .bold))
//                            }
//                    }.scrollTargetLayout()
//                }
//            }.scrollPosition(id: $scrollViewPosition)
//            if scrollViewPosition ?? 0 > 0 {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.red.opacity(0.5))
//                    .frame(width: 100, height: 50)
//            }
//                
//            
//        }
//    }
//}
//
//
//#Preview {
//    ScrollPositionModifier()
//}
