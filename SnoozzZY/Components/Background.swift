//
//  Background.swift
//  SnoozzZY
//
//  Created by Vansh Sharma on 14/09/24.
//
import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            // Background gradient
            Color(red:36/255,green: 0/255,blue: 70/255.0)
                .ignoresSafeArea()
            // Loop to create multiple small circles (stars)
//            ForEach(0..<100, id: \.self) { _ in
//                Circle()
//                    .fill(.white)
//                    .opacity(Double.random(in: 0.3...0.7)) // Vary the opacity to make it more natural
//                    .frame(width: CGFloat.random(in: 2...5), height: CGFloat.random(in: 2...5)) // Random size
//                    .position(
//                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
//                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
//                    ) // Random position across the screen
//            }
        }
    }
}

#Preview {
    Background()
}
