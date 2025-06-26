//
//  Register.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 19/6/2025.
//

import SwiftUI

struct Register: View {
    
    @EnvironmentObject var StreamData : StreamViewModel
    // changing based on colour scheme
    @Environment(\.colorScheme) var colourScheme
    @State private var isLoginMode = false
    @State private var showSignUpView = false
    
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
                            Button(action: {
                                isLoginMode = true
                                showSignUpView.toggle()
                            }) {                                Text("Sign in")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.9))
                                    .foregroundColor(Color.black)
                                    .cornerRadius(20)
                            }

                            Button(action: {
                                isLoginMode = false
                                showSignUpView.toggle()
                            }) {                                Text("Sign up")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.9))
                                    .foregroundColor(Color.black)
                                    .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 40)

                        Spacer()
                        .ignoresSafeArea()
                        
                    }
                    .padding()
                    .background(Color(hex: "#e5c7cd"))
                    .fullScreenCover(isPresented: $showSignUpView) {
                        SignUpView(isLoginMode: isLoginMode, didCompleteLoginProcess: {
                            // Actions to take after sign-in or sign-up
                            self.showSignUpView = false
                            // Possibly navigate or fetch data
                        })
                    }
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

struct Register_Previews: PreviewProvider{
    static var previews: some View{
        Register()
      .environmentObject(StreamViewModel())
        
    }
}
