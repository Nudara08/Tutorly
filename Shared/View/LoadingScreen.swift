//
//  LoadingScreen.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 17/6/2025.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        @Environment(\.colorScheme) var colorScheme
        ZStack{
            
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
            ProgressView()
                .frame(width: 50, height: 50)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(8)
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View{
        LoadingScreen()
    }
}
