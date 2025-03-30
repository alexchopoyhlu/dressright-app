import SwiftUI
import PhotosUI

struct AddClothingItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userStore: UserStore
    
    @State private var name = ""
    @State private var color = ""
    @State private var selectedCategory: ClothingCategory = .tops
    @State private var showingImagePicker = false
    @State private var showingCameraSheet = false
    @State private var selectedImage: UIImage?
    @State private var showingImageSource = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Item Photo").foregroundColor(.white)) {
                        Button(action: {
                            showingImageSource = true
                        }) {
                            HStack {
                                Spacer()
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    Image(systemName: "camera")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                        .frame(width: 100, height: 100)
                                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .cornerRadius(10)
                                }
                                Spacer()
                            }
                        }
                    }
                    .listRowBackground(Color(red: 0.15, green: 0.15, blue: 0.15))
                    
                    Section(header: Text("Item Details").foregroundColor(.white)) {
                        TextField("Name", text: $name)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                        TextField("Color", text: $color)
                            .foregroundColor(.white)
                            .accentColor(.blue)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(ClothingCategory.allCases) { category in
                                Text(category.rawValue)
                                    .foregroundColor(.white)
                                    .tag(category)
                            }
                        }
                        .foregroundColor(.white)
                        .accentColor(.blue)
                    }
                    .listRowBackground(Color(red: 0.15, green: 0.15, blue: 0.15))
                    
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
                    .listRowBackground(Color(red: 0.15, green: 0.15, blue: 0.15))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white))
        }
        .preferredColorScheme(.dark)
        .confirmationDialog("Choose Image Source", isPresented: $showingImageSource) {
            Button("Take Photo") {
                showingCameraSheet = true
            }
            Button("Choose from Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCameraSheet) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
