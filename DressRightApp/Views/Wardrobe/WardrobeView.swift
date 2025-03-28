// WardrobeView.swift
import SwiftUI

struct WardrobeView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var selectedCategory: ClothingCategory?
    @State private var showingAddItemSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Category selection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(ClothingCategory.allCases) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = category
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
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
            .navigationTitle("My Wardrobe")
            .navigationBarItems(trailing: Button(action: {
                showingAddItemSheet = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $showingAddItemSheet) {
                AddClothingItemView()
            }
            .background(Color.black)
        }
    }
    
    var filteredItems: [ClothingItem] {
        if let category = selectedCategory {
            return userStore.wardrobe.filter { $0.category == category }
        } else {
            return userStore.wardrobe
        }
    }
}

struct CategoryButton: View {
    let category: ClothingCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: category.icon)
                    .font(.title2)
                
                Text(category.rawValue)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .gray)
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
