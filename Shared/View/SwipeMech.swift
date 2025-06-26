//
//  SwipeMech.swift
//  Tutorly
//
//  Created by Nudara Jayasinghe on 20/6/2025.
//

import SwiftUI
import SwiftData


struct SwipeMech: View {
    @Environment(\.modelContext) private var context
    @Query private var allProfiles: [Profile]
    @State private var filteredProfiles: [Profile]? = nil
    @State private var showSubjectFilter = true
    @State private var selectedSubject: String = ""
    @State private var didSeed = false
    @State private var selectedTab: Int = 0 // 0: Home, 1: Messages, 2: Profile
    // Helper to normalize subject
    private func normalizeSubject(_ subject: String) -> String {
        subject.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
    }
    // Helper to get all unique normalized subjects
    private var allNormalizedSubjects: [String] {
        // Depend on didSeed to force recompute after seeding
        _ = didSeed
        return Array(Set(allProfiles.map { normalizeSubject($0.subject) })).sorted()
    }
    
    private func applySubjectFilter() {
        if selectedSubject.isEmpty {
            filteredProfiles = allProfiles
        } else {
            filteredProfiles = allProfiles.filter { normalizeSubject($0.subject) == selectedSubject }
        }
    }
    
    var body: some View {
        ZStack {
            if selectedTab == 0 {
                CardStackView(
                    profiles: filteredProfiles ?? allProfiles,
                    showSubjectFilter: $showSubjectFilter
                )
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RemoveSwipedProfile"))) { notification in
                    if let id = notification.object as? Int {
                        // If filteredProfiles is in use, remove the profile from it
                        if var currentFiltered = filteredProfiles {
                            currentFiltered.removeAll { $0.id == id }
                            filteredProfiles = currentFiltered
                        } else {
                            // Otherwise remove the profile directly from allProfiles by applying a new filter
                            filteredProfiles = allProfiles.filter { $0.id != id }
                        }
                    }
                }
                if showSubjectFilter {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("Filter by Subject offered")
                            .font(.title2)
                            .fontWeight(.bold)
//                            ProgressView("Loading subjects...")
//                                                    .padding()
                            Picker("Select Subject", selection: Binding(
                                get: { selectedSubject },
                                set: { selectedSubject = normalizeSubject($0) }
                            )) {
                                ForEach(allNormalizedSubjects, id: \.self) { subject in
                                    Text(subject).tag(subject)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity)
                        Button("Apply Filter") {
                            applySubjectFilter()
                            showSubjectFilter = false
                        }
                        .padding(100)
                        .background(Color(hex: "#b2b3b3"))
                        .cornerRadius(8)
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        // Cancel filtering, show all cards
                                        filteredProfiles = nil
                                        showSubjectFilter = false
                                    }) {
                                    Text("Cancel")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.608, green: 0.482, blue: 0.443)) // brown
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                    }
                                        .buttonStyle(PlainButtonStyle())
                                        .contentShape(Rectangle())
                                        .background(Color.clear)
                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.clear)
                                                    )
                                        .shadow(color: Color(red: 0.608, green: 0.482, blue: 0.443).opacity(0.3), radius: 8, x: 0, y: 4)
                                        .onLongPressGesture(minimumDuration: 0.01, pressing: { isPressing in
                                        if isPressing {
                                            // Add shadow to imitate pressed button
                                        }
                                      }, perform: {})
                                    }
                                }
                                .padding(24)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(40)
            }
            VStack {
                Spacer()
                HStack {
                    // Home icon (filled if selected)
                    Button(action: {
                        selectedTab = 0
                    }) {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                    // Message bubble (not filled)
                    Button(action: {
                        selectedTab = 1
                    }) {
                        Image(systemName: "bubble.left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    // Profile icon (not filled)
                    Button(action: {
                        selectedTab = 2
                    }) {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(Color(hex: "#c9bcba").shadow(radius: 8))
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    .onAppear {
        // Always clear and reseed the database for development/demo
        let fetchRequest = FetchDescriptor<Profile>()
        let profiles = (try? context.fetch(fetchRequest)) ?? []
        for profile in profiles {
            context.delete(profile)
        }
        let initialProfiles = [
            Profile(id: 0, name: "Albert Deran", image: "albert-dera-ILip77SbmOE-unsplash", subject: "Chemistry"),
            Profile(id: 1, name: "Chloe Alexis", image: "alexis-chloe-TYDkKEgc0Fg-unsplash", subject: "Physics"),
            Profile(id: 2, name: "Gabriel Silverio", image: "gabriel-silverio-u3WmDyKGsrY-unsplash", subject: "Maths"),
            Profile(id: 3, name: "Joseph Gonzalez", image: "joseph-gonzalez-iFgRcqHznqg-unsplash", subject: "Maths"),
            Profile(id: 4, name: "Martin Fernandez", image: "mrtiger-PN19hB7_lHE-unsplash", subject: "CHemistry"),
            Profile(id: 5, name: "Nora Hutton", image: "nora-hutton-tCJ44OIqceU-unsplash", subject: "English"),
            Profile(id: 6, name: "Omid Armi", image: "omid-armin-UVx7Xx_b4a0-unsplash", subject: "Business"),
            Profile(id: 7, name: "Terasa", image: "omid-armin-yZwrmzKGKZA-unsplash", subject: "Physics")
        ]
        for profile in initialProfiles {
            context.insert(profile)
        }
        try? context.save()
        didSeed.toggle()
        // Give the view a tick to update the query
        DispatchQueue.main.async {
            filteredProfiles = allProfiles
            if let firstSubject = allNormalizedSubjects.first {
                selectedSubject = firstSubject
            }
        }
    }
}

struct CardStackView: View {
    var profiles: [Profile]
    @Binding var showSubjectFilter: Bool // Use binding
    @State private var activeIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showCreateChannel = false
    @State private var swipedProfileId: Int? = nil
    @EnvironmentObject var streamData: StreamViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header
                HStack(spacing: 15) {
                    Text("Tutors for you")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer(minLength: 0)
                    Button(action: {
                        showSubjectFilter = true // Use binding
                    }) {
                        Text("Filter")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.608, green: 0.482, blue: 0.443))
                            .padding(.leading, 8)
                            .padding(.trailing, 8)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        // Reset filter
                        NotificationCenter.default.post(name: Notification.Name("ResetSubjectFilter"), object: nil)
                    }) {
                        Text("Reset Filters")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading, 4)
                            .padding(.trailing, 4)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .foregroundColor(.black)
                .padding()
                
                Spacer()
                
                // Carousel View
                GeometryReader { geometry in
                    let cardWidth = geometry.size.width * 0.8
                    
                    ZStack {
                        ForEach(Array(profiles.enumerated()), id: \.element.id) { index, profile in
                            if swipedProfileId != profile.id {
                                CarouselCard(
                                    profile: profile,
                                    showCreateChannel: $showCreateChannel,
                                    removeCard: { id in
                                        swipedProfileId = id
                                    }
                                )
                                .frame(width: cardWidth)
                                .padding(.horizontal, 5)
                                .offset(x: calculateOffset(for: index, in: geometry))
                                .zIndex(calculateZIndex(for: index))
                                .scaleEffect(calculateScale(for: index))
                            }
                        }
                        if profiles.filter({ swipedProfileId != $0.id }).isEmpty {
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
                    .onDisappear {
                        if let id = swipedProfileId {
                            // Remove the swiped card from the profiles in the parent view
                            NotificationCenter.default.post(name: Notification.Name("RemoveSwipedProfile"), object: id)
                            swipedProfileId = nil
                        }
                    }
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
                        .fill(Color(red: 0.925, green: 0.682, blue: 0.686)) // #ecaeaf
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
                        
                        Text("Subject: \(profile.subject)")
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
}

@Model
class Profile: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var image: String
    var subject: String

    init(id: Int, name: String, image: String, subject: String) {
        self.id = id
        self.name = name
        self.image = image
        self.subject = subject
    }
}


struct SwipeMech_Previews: PreviewProvider {
    static var previews: some View {
        SwipeMech()
            .environmentObject(StreamViewModel())
    }
}
