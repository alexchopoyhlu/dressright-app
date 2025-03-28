import SwiftUI

struct OutfitDetailView: View {
    let outfit: Outfit
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Perfect for \(outfit.weather.rawValue) weather")
                    .font(.headline)
                    .padding()
                
                List {
                    if let top = outfit.top {
                        ClothingItemRow(item: top)
                    }
                    
                    if let bottom = outfit.bottom {
                        ClothingItemRow(item: bottom)
                    }
                    
                    if let outerwear = outfit.outerwear {
                        ClothingItemRow(item: outerwear)
                    }
                    
                    if let shoes = outfit.shoes {
                        ClothingItemRow(item: shoes)
                    }
                    
                    if !outfit.accessories.isEmpty {
                        Section(header: Text("Accessories")) {
                            ForEach(outfit.accessories) { accessory in
                                ClothingItemRow(item: accessory)
                            }
                        }
                    }
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
            .navigationTitle("Outfit Details")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ClothingItemRow: View {
    let item: ClothingItem
    
    var body: some View {
        HStack {
            Image(systemName: item.category.icon)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.color)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(item.category.rawValue)
                .font(.caption)
                .padding(5)
                .background(Color(.systemGray5))
                .cornerRadius(5)
        }
    }
}
