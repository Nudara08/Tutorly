//
//  SwipeMech.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 20/6/2025.
//

import SwiftUI

struct SwipeMech: View {
    var body: some View {
        CardStackView()
    }
}

struct CardStackView: View {
    @State var profiles = [
        Profile(id: 0, name: "Albert Deran", image: "albert-dera-ILip77SbmOE-unsplash", age: "27", offset: 0),
        Profile(id: 1, name: "Chloe Alexis", image: "alexis-chloe-TYDkKEgc0Fg-unsplash", age: "19", offset: 0),
        Profile(id: 2, name: "Gabriel Silverio", image: "gabriel-silverio-u3WmDyKGsrY-unsplash", age: "25", offset: 0),
        Profile(id: 3, name: "Joseph Gonzalez", image: "joseph-gonzalez-iFgRcqHznqg-unsplash", age: "26", offset: 0),
        Profile(id: 4, name: "Martin Fernandez", image: "mrtiger-PN19hB7_lHE-unsplash", age: "20", offset: 0),
        Profile(id: 5, name: "Nora Hutton", image: "nora-hutton-tCJ44OIqceU-unsplash", age: "22", offset: 0),
        Profile(id: 6, name: "Omid Armi", image: "omid-armin-UVx7Xx_b4a0-unsplash", age: "18", offset: 0),
        Profile(id: 7, name: "Terasa", image: "omid-armin-yZwrmzKGKZA-unsplash", age: "29", offset: 0),
    ]
    
    @State private var activeIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showCreateChannel = false
    @EnvironmentObject var streamData: StreamViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack(spacing: 15) {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                    }
                    
                    Text("Tutorly")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title)
                    }
                }
                .foregroundColor(.black)
                .padding()
                
                Spacer()
                
                // Carousel View
                GeometryReader { geometry in
                    let cardWidth = geometry.size.width * 0.8
                    
                    ZStack {
                        ForEach(Array(profiles.enumerated()), id: \.element.id) { index, profile in
                            CarouselCard(
                                profile: profile,
                                showCreateChannel: $showCreateChannel,
                                removeCard: { id in
                                    withAnimation {
                                        if let index = profiles.firstIndex(where: { $0.id == id }) {
                                            profiles.remove(at: index)
                                            if activeIndex >= profiles.count {
                                                activeIndex = 0
                                            }
                                        }
                                    }
                                }
                            )
                            .frame(width: cardWidth)
                            .padding(.horizontal, 5) // Added horizontal padding
                            .offset(x: calculateOffset(for: index, in: geometry))
                            .zIndex(calculateZIndex(for: index))
                            .scaleEffect(calculateScale(for: index))
                        }
                        if profiles.isEmpty {
                            VStack {
                                Spacer()
                                Text("No more available tutors for your selection. Please try again at another time")
                                    .font(.custom("Didot", size: 24))
                                    .foregroundColor(Color(red: 0.608, green: 0.482, blue: 0.443))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                                Spacer()
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                // Only handle horizontal movement
                                if abs(value.translation.width) > abs(value.translation.height) {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                // Only handle horizontal movement
                                if abs(value.translation.width) > abs(value.translation.height) {
                                    let threshold = cardWidth * 0.4
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        if value.translation.width > threshold {
                                            activeIndex = (activeIndex - 1 + profiles.count) % profiles.count
                                        } else if value.translation.width < -threshold {
                                            activeIndex = (activeIndex + 1) % profiles.count
                                        }
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                
                Spacer()
            }
            .navigationDestination(isPresented: $showCreateChannel) {
                CreateNewChannel()
                    .environmentObject(streamData)
            }
            .background(Color(red: 0.898, green: 0.78, blue: 0.804).edgesIgnoringSafeArea(.all))
        }
    }
    
    private func calculateOffset(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        let cardWidth = geometry.size.width * 0.8
        let spacing: CGFloat = 50 // Increased spacing for more padding
        let adjustedIndex = CGFloat(index - activeIndex)
        // Center the active card by offsetting by half the available width minus half the card width
        let centerOffset = (geometry.size.width - cardWidth) / 2
        let offset = adjustedIndex * (cardWidth + spacing) + dragOffset + centerOffset
        return offset
    }
    
    
    private func calculateZIndex(for index: Int) -> Double {
        let distance = abs(index - activeIndex)
        return Double(profiles.count - distance)
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        let distance = abs(index - activeIndex)
        return 1 - (CGFloat(distance) * 0.1)
    }
}

struct CarouselCard: View {
    let profile: Profile
    @Binding var showCreateChannel: Bool
    let removeCard: (Int) -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Card Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.3), radius: 15, x: 0, y: 5)
                
                // Image with overlay
                Image(profile.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                .black.opacity(0.2),
                                .black.opacity(0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    )
                
                // Profile Information
                VStack(alignment: .leading, spacing: 8) {
                    Text(profile.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Age: \(profile.age)")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 35)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .offset(y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Only handle vertical movement
                        if abs(gesture.translation.height) > abs(gesture.translation.width) {
                            let limitedY = min(0, gesture.translation.height)
                            offset.height = limitedY
                        }
                    }
                    .onEnded { gesture in
                        // Only handle vertical movement
                        if abs(gesture.translation.height) > abs(gesture.translation.width) {
                            let translation = gesture.translation
                            let velocity = gesture.velocity
                            
                            if translation.height < -100 || velocity.height < -500 {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    offset.height = -geometry.size.height
                                    showCreateChannel = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        removeCard(profile.id)
                                    }
                                }
                            } else {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    offset = .zero
                                }
                            }
                        }
                    }
            )
            .overlay(
                VStack {
                    Spacer()
                    if offset.height < -50 {
                        Text("Swipe up to send message request")
                            .font(.custom("Didot", size: 24)) // Use Canela font
                            .foregroundColor(Color(red: 0.608, green: 0.482, blue: 0.443)) // #9b7b71
                            .padding(.bottom, 10)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
            )
        }
        .aspectRatio(0.7, contentMode: .fit)
    }
}

struct Profile: Identifiable {
    var id: Int
    var name: String
    var image: String
    var age: String
    var offset: CGFloat
}

struct SwipeMech_Previews: PreviewProvider {
    static var previews: some View {
        SwipeMech()
            .environmentObject(StreamViewModel())
    }
}
