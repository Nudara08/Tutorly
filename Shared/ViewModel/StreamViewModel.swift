//
//  StreamViewModel.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 17/6/2025.
//

import SwiftUI
import StreamChat

class StreamViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @AppStorage("user name") var storedUser = ""
    @AppStorage("log_Status") var logStatus = false
    
    // Alert...
    @Published var error = false
    @Published var errorMsg = ""
    
    //Loading Screen...
    @Published var IsLoading = false
    
    // Channel Data ...
    @Published var channels : [ChatChannelController.ObservableObject]!
    
    // Create New Channel...
    @Published var createNewChannel = false
    @Published var channelName = ""

    
    func LogInUser(){
        
        // Logging in user...
        
        withAnimation{IsLoading = true}
        
        let config = ChatClientConfig(apiKeyString: "nsfz6wr254ky")
        ChatClient.shared = ChatClient(config: config)
        ChatClient.shared.connectUser(
            userInfo: .init(id: userName),
            token: .development(userId: userName))
        ChatClient.shared.connectAnonymousUser { error in
            withAnimation { self.IsLoading = false}
        ChatClient.shared.currentUserController().reloadUserIfNeeded { (err) in
                
                withAnimation{self.IsLoading = false}
                
                if let error = err{
                    self.errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                    
                }
            }
            // Else successful...
            // storing user names
            self.storedUser = self.userName
            self.logStatus = true
        }
    }
    
    // Fetching All Channels...
    func fetchAllChannels(){
        
        if channels == nil{
            
            //filter...
            let filter = Filter<ChannelListFilterScope>.equal("type", to: "messaging")
            
            let request = ChatClient.shared.channelListController(query: .init(filter:filter))
            request.synchronize{ (err) in
                if let error = err{
                    self.errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                }
                // else Successful...
                self.channels = request.channels.compactMap({ (channel) -> ChatChannelController.ObservableObject? in
                    
                    return ChatClient.shared.channelController(for: channel.cid).observableObject
                })
            }
        }
        
    }
    
    //Creating New Channel...
    func createChannel(){
        
        withAnimation{self.IsLoading = true}
        
        let newChannel = ChannelId(type: .messaging, id: channelName)
        
        // you can give image URL to channel...
        // same you can also give image url to user...
        let request = try! ChatClient.shared.channelController(createChannelWithId: newChannel, name: channelName, imageURL: nil, extraData: [:])
        
        request.synchronize{ (err) in
            
            withAnimation{self.IsLoading = false}
            
            if let error = err{
                self.errorMsg = error.localizedDescription
                self.error.toggle()
                print("Error creating channel: \(error.localizedDescription)") // Debugging statement
                return
            }
            print("Channel created successfully: \(self.channelName)") // Debugging statement
            // Success...
            // closing Loading And New Channel View...
            self.channelName = ""
            withAnimation{self.createNewChannel = false}

        }
    }
    
}
