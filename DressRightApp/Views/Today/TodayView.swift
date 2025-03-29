// TodayView.swift
import SwiftUI

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(color)]
        return self
    }
}

struct GenerateButtonStyle: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(Color.blue)
            .cornerRadius(cornerRadius)
    }
}

struct TodayView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var outfit: Outfit?
    @State private var showingOutfitDetail = false
    @State private var isGenerating = false
    @State private var appearAnimation = false
    
    // Add customizable button properties
    private let generateButtonWidth: CGFloat = 250  // Adjust this value
    private let generateButtonHeight: CGFloat = 55  // Adjust this value
    private let generateButtonCornerRadius: CGFloat = 80  // Adjust this value
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Weather section
                WeatherHeaderView()
                    .padding(.horizontal)
                    .offset(x: 0, y: -35)
                
                // Main content
                if isGenerating {
                    if let outfit = outfit {
                        OutfitSuggestionView(outfit: outfit)
                            .padding()
                            .frame(height: 500)
                            .offset(x: 0, y: 0)
                            .opacity(appearAnimation ? 1 : 0)
                            .scaleEffect(appearAnimation ? 1 : 0.9)
                            .animation(.spring(response: 1.0, dampingFraction: 0.8, blendDuration: 0), value: appearAnimation)
                    } else {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxHeight: .infinity)
                            .transition(.opacity)
                    }
                } else {
                    // Generate button
                    VStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isGenerating = true
                            }
                            // Simulate loading time
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                outfit = userStore.getTodayOutfit()
                                withAnimation {
                                    appearAnimation = true
                                }
                            }
                        }) {
                            Text("Generate Today's Outfit")
                                .modifier(GenerateButtonStyle(
                                    width: generateButtonWidth,
                                    height: generateButtonHeight,
                                    cornerRadius: generateButtonCornerRadius
                                ))
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                }
                
                Spacer()
                
                // Action buttons (only show when outfit is generated)
                if isGenerating && outfit != nil {
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation {
                                appearAnimation = false
                            }
                            // Reset after animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isGenerating = false
                                outfit = nil
                            }
                        }) {
                            Text("Skip")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(red: 0.6, green: 0.1, blue: 0.0))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            self.showingOutfitDetail = true
                        }) {
                            Text("Wear Today")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 20)
                    .animation(.spring(response: 1.3, dampingFraction: 0.8, blendDuration: 0).delay(0.2), value: appearAnimation)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Today's")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Outfit")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .offset(x: 6, y: 25)
                }
            }
            .background(Color.black)
            .sheet(isPresented: $showingOutfitDetail) {
                if let outfit = outfit {
                    OutfitDetailView(outfit: outfit)
                }
            }
        }
    }
}

struct WeatherHeaderView: View {
    let temperature = "23°C"
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
                
                Text("Sunny today in Newcastle")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 12)
        .offset(x: -6, y: 12)
    }
}

struct OutfitSuggestionView: View {
    let outfit: Outfit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 45) {
            Text("Your outfit for today:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                if let top = outfit.top {
                    ClothingItemView(item: top)
                        .frame(height: 120)
                }
                if let bottom = outfit.bottom {
                    ClothingItemView(item: bottom)
                        .frame(height: 120)
                }
                if let outerwear = outfit.outerwear {
                    ClothingItemView(item: outerwear)
                        .frame(height: 120)
                }
                if let shoes = outfit.shoes {
                    ClothingItemView(item: shoes)
                        .frame(height: 120)
                }
            }
            .padding(.horizontal, 8)
            
            if !outfit.accessories.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Accessories")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(outfit.accessories) { accessory in
                            ClothingItemView(item: accessory)
                                .frame(height: 120)
                        }
                    }
                    .padding(.horizontal, 8)
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
                    if item.name.lowercased().contains("jeans") {
                        Image("jeans", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    } else {
                        Image(systemName: "square.fill")
                            .font(.system(size: 30))
                            .rotationEffect(.degrees(90))
                    }
                case .outerwear:
                    if item.name.lowercased().contains("hoodie") {
                        Image("hoodie", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    } else {
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: 30))
                    }
                case .shoes:
                    Image("shoes", bundle: nil)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                case .accessories:
                    if item.name.lowercased().contains("sunglasses") {
                        Image("sunglasses", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    } else if item.name.lowercased().contains("hat") {
                        Image("hat", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(20)
                    } else {
                        Image(systemName: item.category.icon)
                            .font(.system(size: 30))
                    }
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
        MainTabView()
            .environmentObject(UserStore())
            .preferredColorScheme(.dark)
    }
}
