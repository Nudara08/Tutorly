//
//  SignUpView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 18/6/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage


struct SignUpView:View {
    
    @State var isLoginMode: Bool = false
    @State var email = ""
    @State var password = ""
    @State var userType = "" // New state for dropdown
    @State var LoginStatusMessage = ""
    @State private var showLoadingScreen = false
    @State var shouldShowImagePicker = false
    @State private var navigateToSwipeMech = false
    @State private var navigateToLoadingScreen = false
    let didCompleteLoginProcess: () -> ()
    
    
    var body: some View {
        ZStack {
            if navigateToSwipeMech {
                SwipeMech().environmentObject(StreamViewModel())
            } else if navigateToLoadingScreen {
                LoadingScreen()
            } else {
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
                                    shouldShowImagePicker.toggle()
                                } label: {
                                    VStack {
                                        if let image = self.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 128, height: 128)
                                                .cornerRadius(64)
                                        } else {
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 64))
                                                .padding()
                                                .foregroundColor(Color(.label))
                                        }
                                    }
                                    .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3)
                                    )
                                    
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
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                    SecureField("Password", text: $password)
                                        .font(.custom("Didot", size: 16))
                                        .padding(12)
                                        .background(Color.clear)
                                        .overlay(RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.black, lineWidth: 2))
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                    // Dropdown menu for user type with label
                                    HStack {
                                        Text("I am a...")
                                            .font(.custom("Didot", size: 16))
                                            .foregroundColor(.gray)
                                        Picker(selection: $userType, label: EmptyView()) {
                                            Text("student").tag("student")
                                            Text("tutor").tag("tutor")
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .frame(maxWidth: .infinity, minHeight: 36) // reduced minHeight
                                        .padding(.leading, -8)
                                    }
                                    .padding(8) // reduced padding
                                    .background(Color.clear)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.black, lineWidth: 2))
                                    .frame(maxWidth: .infinity, minHeight: 36) // reduced minHeight
                                }
                            } else {
                                Group {
                                    TextField("Email", text: $email)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .font(.custom("Didot", size: 16))
                                    
                                        .padding(12)
                                        .background(Color.clear)
                                        .overlay(RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.black, lineWidth: 2))
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                    SecureField("Password", text: $password)
                                        .font(.custom("Didot", size: 16))
                                        .padding(12)
                                        .background(Color.clear)
                                        .overlay(RoundedRectangle(cornerRadius: 2)
                                            .stroke(Color.black, lineWidth: 2))
                                        .frame(maxWidth: .infinity, minHeight: 44)
                                }
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
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                }
            }
        }
    }
    
    @State var image: UIImage?
    
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
                self.LoginStatusMessage = "Failed to login user. PLease try again"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "Successfully logged in"
            // Fetch userType from Firestore and navigate accordingly
            if let uid = result?.user.uid {
                let db = Firestore.firestore()
                db.collection("users").document(uid).getDocument { document, error in
                    if let document = document, document.exists, let data = document.data(), let userType = data["userType"] as? String {
                        DispatchQueue.main.async {
                            if userType == "student" {
                                self.navigateToSwipeMech = true
                            } else {
                                self.navigateToLoadingScreen = true
                            }
                        }
                    } else {
                        print("User document does not exist or userType missing.")
                    }
                }
            }
        }
    }
    
    
    private func CreateNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            
            if let err = err as NSError? {
                if err.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.LoginStatusMessage = "Password already has a registered account. Try logging in."
                } else {
                    self.LoginStatusMessage = "Failed to create user. Please try again"
                }
                return
                
            }
            print ("Successfully created user: \(result?.user.uid ?? "")")
            self.LoginStatusMessage = "Successfully created user. Please log in."

            self.persistImageToStorage()
            
            
            // Save userType to Firestore
            if let uid = result?.user.uid {
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "email": email,
                    "password": password,
                    "userType": userType
                ]) { error in
                    if let error = error {
                        print("Error saving userType: \(error)")
                    } else {
                        print("UserType saved successfully.")
                    }
                }
            }
        }
        
    }
    private func persistImageToStorage() {
        //        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.LoginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.LoginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.LoginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
                self.storeUserInformation(imageProfileUrl: url!)
            }
        }
    }
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.LoginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
            }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(didCompleteLoginProcess: {
            
        })
    .environmentObject(StreamViewModel())
        

    }
}
