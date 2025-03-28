// ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        NavigationView {
            List {
                // Profile header
                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text(userStore.name.isEmpty ? "DressRight User" : userStore.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(userStore.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                // Subscription section
                Section(header: Text("Subscription").foregroundColor(.white)) {
                    HStack {
                        Text("Your Plan")
                            .foregroundColor(.white)
                        Spacer()
                        Text(userStore.subscriptionTier.rawValue)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Daily Outfit Suggestions")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(userStore.subscriptionTier.outfitSuggestionsPerDay)")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Price")
                            .foregroundColor(.white)
                        Spacer()
                        Text(userStore.subscriptionTier.price)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        // Upgrade subscription
                    }) {
                        Text(userStore.subscriptionTier == .basic ? "Upgrade to Premium" : "Manage Subscription")
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                }
                
                // Wardrobe stats
                Section(header: Text("Wardrobe Stats").foregroundColor(.white)) {
                    HStack {
                        Text("Total Items")
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(userStore.wardrobe.count)")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    // Add more stats here
                }
                
                // App settings
                Section(header: Text("Settings").foregroundColor(.white)) {
                    Button(action: {
                        // Future: Implement notification settings
                    }) {
                        Text("Notification Settings")
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        // Future: Implement privacy settings
                    }) {
                        Text("Privacy Settings")
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        userStore.logout()
                    }) {
                        Text("Log Out")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .background(Color.black)
        }
    }
}
