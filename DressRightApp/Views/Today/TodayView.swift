// TodayView.swift
import SwiftUI

struct TodayView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var outfit: Outfit?
    @State private var showingOutfitDetail = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Weather section
                WeatherHeaderView()
                    .padding(.horizontal)
                
                // Outfit suggestion section
                if let outfit = outfit {
                    OutfitSuggestionView(outfit: outfit)
                        .padding()
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
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: {
                        // Skip this outfit
                    }) {
                        Text("Skip")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        self.showingOutfitDetail = true
                    }) {
                        Text("Wear Today")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Today's Outfit")
            .background(Color.black)
            .sheet(isPresented: $showingOutfitDetail) {
                if let outfit = outfit {
                    OutfitDetailView(outfit: outfit)
                }
            }
            .onAppear {
                outfit = userStore.getTodayOutfit()
            }
        }
    }
}

struct WeatherHeaderView: View {
    let temperature = "72°F"
    let condition: WeatherCondition = .sunny
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: condition.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.yellow)
                    
                    Text(temperature)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text("Sunny today in New York")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 12)
    }
}

struct OutfitSuggestionView: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Your outfit for today:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
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
                VStack(alignment: .leading, spacing: 12) {
                    Text("Accessories")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(outfit.accessories) { accessory in
                            ClothingItemView(item: accessory)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .cornerRadius(16)
    }
}

struct ClothingItemView: View {
    let item: ClothingItem
    
    var body: some View {
        VStack(spacing: 8) {
            Group {
                switch item.category {
                case .tops:
                    if item.name.lowercased().contains("white") {
                        Image("white_tshirt", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    } else {
                        Image(systemName: item.category.icon)
                            .font(.system(size: 30))
                    }
                case .bottoms:
                    Image(systemName: "square.fill")
                        .font(.system(size: 30))
                        .rotationEffect(.degrees(90))
                case .outerwear:
                    Image(systemName: "rectangle.fill")
                        .font(.system(size: 30))
                case .shoes:
                    Image(systemName: "bolt.horizontal.fill")
                        .font(.system(size: 30))
                        .rotationEffect(.degrees(-45))
                case .accessories:
                    Image(systemName: item.category.icon)
                        .font(.system(size: 30))
                case .dresses:
                    Image(systemName: "rectangle.fill")
                        .font(.system(size: 30))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
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
