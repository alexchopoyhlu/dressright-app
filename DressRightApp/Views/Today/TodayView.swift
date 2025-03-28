// TodayView.swift
import SwiftUI

struct TodayView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var outfit: Outfit?
    @State private var showingOutfitDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Weather section
                WeatherHeaderView()
                
                // Outfit suggestion section
                if let outfit = outfit {
                    OutfitSuggestionView(outfit: outfit)
                        .padding()
                    
                    // Action buttons
                    HStack {
                        Button(action: {
                            // Skip this outfit
                        }) {
                            Text("Skip")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Accept this outfit
                            self.showingOutfitDetail = true
                        }) {
                            Text("Wear Today")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "tshirt")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("No outfit suggestions yet")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("Add clothes to your wardrobe to get started")
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Today's Outfit")
            .background(Color.black)
            .sheet(isPresented: $showingOutfitDetail) {
                if let outfit = outfit {
                    OutfitDetailView(outfit: outfit)
                }
            }
            .onAppear {
                // Get today's outfit
                outfit = userStore.getTodayOutfit()
            }
        }
    }
}

struct WeatherHeaderView: View {
    // In a real app, this would be fetched from a weather API
    let temperature = "72°F"
    let condition: WeatherCondition = .sunny
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: condition.icon)
                    .font(.system(size: 45))
                    .foregroundColor(condition.color)
                
                Text(temperature)
                    .font(.system(size: 45, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text("\(condition.rawValue) today in New York")
                .font(.title3)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
    }
}

struct OutfitSuggestionView: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Your outfit for today:")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 25) {
                if let top = outfit.top {
                    ClothingItemView(item: top)
                }
                
                if let bottom = outfit.bottom {
                    ClothingItemView(item: bottom)
                }
                
                if let outerwear = outfit.outerwear {
                    ClothingItemView(item: outerwear)
                }
                
                if let shoes = outfit.shoes {
                    ClothingItemView(item: shoes)
                }
            }
            
            if !outfit.accessories.isEmpty {
                Text("Accessories")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 15) {
                    ForEach(outfit.accessories) { accessory in
                        ClothingItemView(item: accessory)
                            .frame(width: 60, height: 60)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
        )
    }
}

struct ClothingItemView: View {
    let item: ClothingItem
    
    var body: some View {
        VStack {
            // In a real app, this would load the image from your database
            // For now, we'll use a placeholder
            Image(systemName: item.category.icon)
                .font(.system(size: 35))
                .frame(width: 70, height: 70)
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(10)
            
            Text(item.name)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.white)
        }
    }
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(UserStore())
    }
}
