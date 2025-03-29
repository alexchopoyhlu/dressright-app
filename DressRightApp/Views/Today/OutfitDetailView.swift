import SwiftUI

struct OutfitDetailView: View {
    let outfit: Outfit
    @Environment(\.presentationMode) var presentationMode
    @State private var scrollOffset: CGFloat = 0
    
    // Adjust these values to control positioning
    private let titleTopPadding: CGFloat = 30
    private let headerHeight: CGFloat = 100 // Approximate height of header area
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Custom title positioning
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Outfit Details")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top, titleTopPadding)
                            
                            Text("Perfect for \(outfit.weather.rawValue) weather")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.top, 4)
                                .padding(.bottom, 25)
                        }
                        Spacer()
                    }
                    .zIndex(1) // Ensure header stays above list
                    
                    // Scroll position reader
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 0) {
                                // Scroll position tracker
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: OffsetPreferenceKey.self,
                                        value: proxy.frame(in: .named("scrollView")).minY
                                    )
                                }
                                .frame(height: 0)
                                
                                // List content
                                VStack(spacing: 0) {
                                    if let top = outfit.top {
                                        ClothingItemDetailRow(item: top)
                                    }
                                    
                                    if let bottom = outfit.bottom {
                                        ClothingItemDetailRow(item: bottom)
                                    }
                                    
                                    if let outerwear = outfit.outerwear {
                                        ClothingItemDetailRow(item: outerwear)
                                    }
                                    
                                    if let shoes = outfit.shoes {
                                        ClothingItemDetailRow(item: shoes)
                                    }
                                    
                                    if !outfit.accessories.isEmpty {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Accessories")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 16)
                                                .padding(.top, 16)
                                            
                                            ForEach(outfit.accessories) { accessory in
                                                ClothingItemDetailRow(item: accessory)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 8)
                            }
                        }
                        .coordinateSpace(name: "scrollView")
                        .onPreferenceChange(OffsetPreferenceKey.self) { value in
                            scrollOffset = value
                        }
                        .background(Color.black)
                        .mask(
                            // Apply gradient mask when scrolled
                            VStack(spacing: 0) {
                                // Fade in effect at the top
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .black.opacity(scrollOffset < 0 ? 0 : 1), location: 0),
                                        .init(color: .black, location: min(0.15, max(0.05, abs(scrollOffset) / 50)))
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 40)
                                
                                // Main content area
                                Rectangle().fill(Color.black)
                            }
                        )
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Confirm Outfit")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationBarHidden(true) // Hide the default navigation bar
                .background(Color.black)
                .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .accentColor(.blue)
    }
}

// Preference key to track scroll position
struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ClothingItemDetailRow: View {
    let item: ClothingItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon container
            ZStack {
                Color(red: 0.15, green: 0.15, blue: 0.15)
                    .cornerRadius(10)
                    .frame(width: 60, height: 60)
                
                Group {
                    switch item.category {
                    case .tops:
                        if item.name.lowercased().contains("white") {
                            Image("white_tshirt", bundle: nil)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        } else {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    case .bottoms:
                        if item.name.lowercased().contains("jeans") {
                            Image("jeans", bundle: nil)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        } else {
                            Image(systemName: "square.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(90))
                        }
                    case .outerwear:
                        if item.name.lowercased().contains("hoodie") {
                            Image("hoodie", bundle: nil)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        } else {
                            Image(systemName: "rectangle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    case .shoes:
                        Image("shoes", bundle: nil)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                    case .accessories:
                        if item.name.lowercased().contains("sunglasses") {
                            Image("sunglasses", bundle: nil)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        } else if item.name.lowercased().contains("hat") {
                            Image("hat", bundle: nil)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .padding(8)
                        } else {
                            Image(systemName: item.category.icon)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    case .dresses:
                        Image(systemName: "rectangle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(item.color)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(item.category.rawValue)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color(red: 0.3, green: 0.3, blue: 0.3))
                .cornerRadius(5)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}
