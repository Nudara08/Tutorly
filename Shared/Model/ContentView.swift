//
//  ContentView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 8/6/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var streamData: StreamViewModel
    @AppStorage("log_Status") var logStatus = false

    
    var body: some View {
        NavigationView{
            
            if !logStatus{
                Login()
                    .navigationTitle("Login")
            }
            else{
                ChannelView()
            }
        }
        .alert(isPresented: $streamData.error, content: {
            Alert(title: Text(streamData.errorMsg))
        })
        .overlay(
            ZStack {
                if streamData.IsLoading {
                    LoadingScreen()
                }
                // New Channel View...
                if streamData.createNewChannel{CreateNewChannel()}
            }
        )
        .environmentObject(streamData)
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
      .environmentObject(StreamViewModel())
        
    }
}

