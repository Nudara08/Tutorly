//
//  DataItem.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 25/6/2025.
//

import Foundation
import SwiftData

@Model
class DataItem : Identifiable {
    
    var id: String
    var name: String
    
    init(name: String) {
        
        self.id = UUID().uuidString
        self.name = name
    }
}
