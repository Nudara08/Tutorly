//
//  ChannelView.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 17/6/2025.
//

import SwiftUI

struct ChannelView: View {
    @EnvironmentObject var streamData: StreamViewModel
    var body: some View {
        // Channel View...
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 15){
                if let channels = streamData.channels{
                    ForEach(channels,id: \.channel){channel in
                        
                        Text(channel.channel?.name ?? "")
                    }
                }
                else{
                    //Progress View...
                    ProgressView()
                        .padding(.top, 30)
                }
            }
            
        })
        .navigationTitle("Channel")
        // Navigation Bar Buttons...
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    streamData.channels = nil
                    streamData.fetchAllChannels()
                }, label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing){
                
                Button(action: {
                    withAnimation{streamData.createNewChannel.toggle()}
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            }
        })
        .onAppear(perform: {
            streamData.fetchAllChannels()
        })
    }
}

#Preview {
    ChannelView()
    .environmentObject(StreamViewModel())

}
