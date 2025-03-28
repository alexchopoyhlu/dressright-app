import SwiftUI

struct AddClothingItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userStore: UserStore
    
    @State private var name = ""
    @State private var color = ""
    @State private var selectedCategory: ClothingCategory = .tops
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Photo").foregroundColor(.white)) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "camera")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                                .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
                
                Section(header: Text("Item Details").foregroundColor(.white)) {
                    TextField("Name", text: $name)
                        .foregroundColor(.white)
                    TextField("Color", text: $color)
                        .foregroundColor(.white)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(ClothingCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        let newItem = ClothingItem(
                            name: name,
                            category: selectedCategory,
                            color: color,
                            imageURL: "placeholder"
                        )
                        userStore.addClothingItem(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Add to Wardrobe")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .disabled(name.isEmpty || color.isEmpty)
                }
            }
            .navigationTitle("Add New Item")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .background(Color.black)
        }
    }
}
