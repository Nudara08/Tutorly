//
//  SignInView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI

struct SignInView:View {
    
    @EnvironmentObject var StreamData : StreamViewModel
    
    
    // changing based on colour scheme
    @Environment(\.colorScheme) var colourScheme

    
    var body: some View {
        VStack{
            Spacer()
            TextField("Username", text: $StreamData.userName)
                .modifier(ShadowModifier())
                .padding(.top, 30)
            
            Button(action: StreamData.LogInUser , label: {
                HStack{
                    Spacer()
                    
                    Text("Login")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.primary)
                .foregroundColor(colourScheme == .dark ? .black : .white)
                .cornerRadius(5)
            })
            .padding(.top, 20)
            .disabled(StreamData.userName == "")
            .opacity(StreamData.userName == "" ? 0.5 : 1)
            Spacer()
        }
        .padding()
        }
    }

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    .environmentObject(StreamViewModel())

    }
}

// creating a Modifier for shadow so that it can be used for some other views...

struct ShadowModifier: ViewModifier{
    
    // changing based on colour scheme
    @Environment(\.colorScheme) var colourScheme
    func body(content: Content) -> some View {
        
        return content
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(colourScheme != .dark ? Color.white : Color.black)
            .cornerRadius(8)
            .clipped()
            .shadow(color: Color.primary.opacity(0.0), radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.0), radius: 5, x: -5, y: -5)
    }
}
