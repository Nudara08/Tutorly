//
//  SignUpView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 18/6/2025.
//

import SwiftUI

import SwiftUI

struct Login:View {
    
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    .environmentObject(StreamViewModel())

    }
}


