// HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userStore: UserStore
    
    var sortedOutfits: [Outfit] {
        userStore.outfitHistory.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(sortedOutfits) { outfit in
                            OutfitHistoryRow(outfit: outfit)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Outfit History")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct OutfitHistoryRow: View {
    let outfit: Outfit
    @State private var isExpanded = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            // Collapsed view (always visible)
            Button(action: {
                UIImpactFeedbackGenerator.rigidImpact()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateFormatter.string(from: outfit.date))
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(outfit.weather.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Image(systemName: outfit.weather.icon)
                            .font(.system(size: 24))
                            .foregroundColor(outfit.weather.color)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                }
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                .cornerRadius(isExpanded ? 10 : 10)
            }
            
            // Expanded view (visible when expanded)
            if isExpanded {
                VStack(spacing: 12) {
                    if let top = outfit.top {
                        OutfitItemRow(item: top)
                    }
                    
                    if let bottom = outfit.bottom {
                        OutfitItemRow(item: bottom)
                    }
                    
                    if let outerwear = outfit.outerwear {
                        OutfitItemRow(item: outerwear)
                    }
                    
                    if let shoes = outfit.shoes {
                        OutfitItemRow(item: shoes)
                    }
                    
                    if !outfit.accessories.isEmpty {
                        ForEach(outfit.accessories) { accessory in
                            OutfitItemRow(item: accessory)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            }
        }
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(10)
    }
}

struct OutfitItemRow: View {
    let item: ClothingItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Miniature clothing image
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.1)
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                Group {
                    switch item.category {
                    case .tops:
                        if item.name.lowercased().contains("white") {
                            Image("white_tshirt")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 20))
                        }
                    case .bottoms:
                        if item.name.lowercased().contains("jeans") {
                            Image("jeans")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "square.fill")
                                .font(.system(size: 20))
                                .rotationEffect(.degrees(90))
                        }
                    case .outerwear:
                        if item.name.lowercased().contains("hoodie") {
                            Image("hoodie")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "rectangle.fill")
                                .font(.system(size: 20))
                        }
                    case .shoes:
                        Image("shoes")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                    case .accessories:
                        if item.name.lowercased().contains("sunglasses") {
                            Image("sunglasses")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        } else if item.name.lowercased().contains("hat") {
                            Image("hat")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 20))
                        }
                    case .dresses:
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: 20))
                    }
                }
                .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text(item.color)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(item.category.rawValue)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(4)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(UserStore())
    }
}
