//
//  ContentView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                    VStack(spacing: 30) {
                        Spacer()

                        // App Icon
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .foregroundColor(.white)

                        
                        // Tagline
                        VStack(spacing: 4) {
                            Text("Swipe")
                            Text("Match")
                            Text("Achieve")
                        }
                        .font(.custom("Didot", size: 24))
                        .foregroundColor(Color(hex: "#9b7b71"))

                        Spacer()

                        // Buttons
                        VStack(spacing: 15) {
                            NavigationLink(destination: SignInView()) {
                                Text("Sign in")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.9))
                                    .foregroundColor(Color.black)
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: SignUpView()) {
                                Text("Sign up")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.9))
                                    .foregroundColor(Color.black)
                                    .cornerRadius(21)
                            }
                        }
                        .padding(.horizontal, 40)

                        Spacer()
                    }
                    .padding()
                    .background(Color(hex: "#e5c7cd"))
                    .ignoresSafeArea()
                }
            }
    }
// MARK: - Extension for Hex Color Support
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Skip the #
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}               

#Preview {
    ContentView()
}
