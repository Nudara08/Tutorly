//
//  ProfileView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 27/6/2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userType: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
            VStack(spacing: 24) {
                Text("Your Profile")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Email:")
                            .bold()
                        Spacer()
                        Text(email)
                    }
                    HStack {
                        Text("Password:")
                            .bold()
                        Spacer()
                        Text(password.isEmpty ? "••••••••" : password)
                    }
                    HStack {
                        Text("Account Type:")
                            .bold()
                        Spacer()
                        Text(userType)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        // First button to navigate to HomeView
                        NavigationLink(destination: SwipeMech()) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                        Spacer()
                        // Second button to navigate to ChannelView
                        NavigationLink(destination: ChannelView()) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                        Spacer()
                        // Third button to navigate to ProfileView
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                                .frame(maxHeight: .infinity, alignment: .center)
                        }
                    Spacer()
                }
                .frame(height: 44, alignment: .center)
                .background(Color(red: 0.788, green: 0.737, blue: 0.729)) // #c9bcba
                .ignoresSafeArea(edges: .bottom)
            }
            .onAppear(perform: fetchUserInfo)
    }

    
    func fetchUserInfo() {
        guard let user = FirebaseManager.shared.auth.currentUser else {
            errorMessage = "No user logged in."
            return
        }
        self.email = user.email ?? "Unknown"
        // Passwords are not accessible from Firebase Auth for security reasons
        self.password = "(hidden)"
        // Dummy account type fetch (replace with your logic if you store account type in Firestore)
        let uid = user.uid
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch account type: \(error.localizedDescription)"
                return
            }
            let data = snapshot?.data() ?? [:]
            self.userType = data["userType"] as? String ?? "Unknown"
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
