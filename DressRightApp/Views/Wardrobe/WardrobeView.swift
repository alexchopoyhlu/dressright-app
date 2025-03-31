// WardrobeView.swift
import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var selectedCategory: String = "All"
    @State private var showingAddItemSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Category Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(["All"] + ClothingCategory.allCases.map { $0.rawValue }, id: \.self) { category in
                                CategoryButton(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color.black)
                    
                    // Clothing items grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(filteredItems) { item in
                                WardrobeItemCard(item: item)
                                    .frame(height: 180)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Wardrobe")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarItems(trailing: Button(action: {
                showingAddItemSheet = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $showingAddItemSheet) {
                AddClothingItemView()
            }
        }
    }
    
    private var filteredItems: [ClothingItem] {
        if selectedCategory == "All" {
            return userStore.wardrobe
        }
        return userStore.wardrobe.filter { $0.category.rawValue == selectedCategory }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Group {
                    if title == "All" {
                        Image(systemName: "square.grid.2x2")
                            .font(.title2)
                    } else {
                        switch ClothingCategory(rawValue: title) {
                        case .tops:
                            Image(systemName: "tshirt")
                                .font(.title2)
                        case .bottoms:
                            Image("pants")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        case .outerwear:
                            Image("jacket")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        case .dresses:
                            Image("dress")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        case .shoes:
                            Image(systemName: "shoe.2")
                                .font(.title2)
                        case .accessories:
                            Image("sunglasses")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        case .none:
                            EmptyView()
                        }
                    }
                }
                .foregroundColor(isSelected ? .white : .gray)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? Color.blue : Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(10)
        }
    }
}

struct WardrobeItemCard: View {
    let item: ClothingItem
    
    var body: some View {
        VStack {
            // In a real app, this would load the image from your database
            Image(systemName: item.category.icon)
                .font(.system(size: 45))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(10)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    
                    Text(item.color)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    // Toggle favorite
                }) {
                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(item.isFavorite ? .red : .gray)
                }
            }
            .padding(8)
        }
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 5)
    }
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
            .environmentObject(UserStore())
    }
}
