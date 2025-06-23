//
//  Credential.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 18/6/2025.
//

import SwiftUI
import StreamChat

let APIKey = "nsfz6wr254ky"
let config = ChatClientConfig(apiKey: .init(apiKeyString))
let client = ChatClient(config: config)
let streamChat = StreamChat(chatClient: chatClient)
