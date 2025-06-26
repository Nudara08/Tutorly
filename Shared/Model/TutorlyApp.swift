//
//  TutorlyApp.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI
import StreamChat
import Firebase
import SwiftData

@main
struct TutorlyApp: App {
    init() {
            FirebaseApp.configure()  // Configure here before anything else
        }
    
    // Calling Delegate...
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            SwipeMech()
        }
        .modelContainer(for: [Profile.self]) 
    }
}



// Delegate ...
class AppDelegate: NSObject, UIApplicationDelegate{
    

    // different way of initialising the Stream ...
    
    @AppStorage("UserName") var storedUser = ""
    @AppStorage("log_status") var logStatus = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let config = ChatClientConfig(apiKeyString: "nsfz6wr254ky")
        ChatClient.shared = ChatClient(config: config)

        // if user is logged in...
        if logStatus {
            ChatClient.shared.connectUser(userInfo: .init(id: storedUser), token: .development(userId: storedUser))
        }
        else{
            
            ChatClient.shared.connectAnonymousUser()
            ChatClient.shared.connectAnonymousUser()
//            ChatClient.shared = ChatClient(config: config, TokenProvider: .anonymous)

        }
        
        return true
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


// Stream API...

extension ChatClient{
    static var shared: ChatClient!
}
