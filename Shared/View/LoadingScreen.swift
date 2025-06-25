//
//  LoadingScreen.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 17/6/2025.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        ZStack{
            Color(hex: "#e5c7cd")
                .ignoresSafeArea()
            DotsLoadingView()
        }
    }
}

struct DotsLoadingView: View {
    @State private var activeDot = 0
    let dotCount = 8
    let dotSize: CGFloat = 22
    let radius: CGFloat = 48
    let animationDuration: Double = 0.9
    var body: some View {
        ZStack {
            ForEach(0..<dotCount, id: \.self) { i in
                Circle()
                    .fill(i == activeDot ? Color(hex: "#ab9895") : Color(hex: "#c9bcba"))
                    .frame(width: dotSize, height: dotSize)
                    .offset(x: 0, y: -radius)
                    .rotationEffect(.degrees(Double(i) / Double(dotCount) * 360))
            }
        }
        .frame(width: radius * 2 + dotSize, height: radius * 2 + dotSize)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: animationDuration / Double(dotCount), repeats: true) { _ in
                activeDot = (activeDot + 1) % dotCount
            }
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View{
        LoadingScreen()
    }
}
