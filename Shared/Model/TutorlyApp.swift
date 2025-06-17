//
//  TutorlyApp.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI
import StreamChat

@main
struct message_testApp: App {
    
    // Calling Delegate...
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environmentObject(StreamViewModel()) // ✅ required
        }
    }
}

// Delegate ...
class AppDelegate: NSObject, UIApplicationDelegate{
    

    // different way of initialising the Stream ...
    
    @AppStorage("UserName") var storedUser = ""
    @AppStorage("log_status") var logStatus = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        ChatClient.shared.connectUser(userInfo: .init(id: storedUser), token: .development(userId: storedUser))
//        ChatClient.shared = ChatClient(config: config)

        if logStatus {
            ChatClient.shared.connectUser(userInfo: .init(id: storedUser), token: .development(userId: storedUser)
            )
        }
        else{
            
//            ChatClient.shared = ChatClient(config: config)
            
            ChatClient.shared.connectAnonymousUser()
        }
        
        return true
    }
}

// Stream API...

extension ChatClient{
    static var shared: ChatClient!
}
