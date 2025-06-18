//
//  Modifiers.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 18/6/2025.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
    }
}
