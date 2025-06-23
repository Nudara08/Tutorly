//
//  SignUpView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 18/6/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth


class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
    
}

struct SignUpView:View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here").font(.custom("Didot", size: 16))) {
                        Text("Login")
                            .tag(true)
                            .font(.custom("Didot", size: 16))
                        Text("Create Account")
                            .tag(false)
                            .font(.custom("Didot", size: 16))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onAppear {
                        let selectedColor = UIColor(red: 236/255, green: 174/255, blue: 175/255, alpha: 1.0) // #ecaeaf
                        UISegmentedControl.appearance().selectedSegmentTintColor = selectedColor
                        UISegmentedControl.appearance().setTitleTextAttributes([
                            .font: UIFont(name: "Didot", size: 16) ?? UIFont.systemFont(ofSize: 16)
                                                ], for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes([
                            .font: UIFont(name: "Didot", size: 16) ?? UIFont.systemFont(ofSize: 16)
                                                ], for: .selected)
                    }

                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .font(.custom("Didot", size: 16))
                            .padding(12)
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.black, lineWidth: 2))
                        SecureField("Password", text: $password)
                            .font(.custom("Didot", size: 16))
                            .padding(12)
                            .background(Color.clear)
                            .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.black, lineWidth: 2))
                    }
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .background(Color(hex: "#b2b3b3"))
                        .cornerRadius(8)
                    }
                    
                    Text(self.LoginStatusMessage)
                        .foregroundStyle(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .font(.custom("Didot", size: 20))
            .background(Color(hex: "#e5c7cd")
                            .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction() {
        if isLoginMode {
//            print("Should log into Firebase with existing credentials")
            loginUser()
        } else {
            CreateNewAccount()
//            print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
        }
    }
    
    private func loginUser() {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Failed to login user:", err)
                    self.LoginStatusMessage = "Failed to login user: \(err)"
                    return
                }
                
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
                
                self.LoginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            }
        }
    
    @State var LoginStatusMessage = ""
    private func CreateNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user", err)
                self.LoginStatusMessage = "Failed to create user: \(err)"
                
            }
            print ("Successfully created user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
            
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    .environmentObject(StreamViewModel())
        

    }
}
