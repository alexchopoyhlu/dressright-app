// ProfileView.swift
import SwiftUI

struct GradientText: View {
    let text: String
    @State private var animateGradient = false
    
    var body: some View {
        Text(text)
            .fontWeight(.medium)
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        .blue,
                        .purple,
                        .pink,
                        .blue,
                        .purple,
                        .pink
                    ],
                    startPoint: animateGradient ? .topLeading : .bottomLeading,
                    endPoint: animateGradient ? .bottomTrailing : .topTrailing
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userStore: UserStore
    @State private var name: String
    @State private var email: String
    @State private var showingImagePicker = false
    @State private var showingImageOptions = false
    @State private var selectedImage: UIImage?
    @State private var showingDeleteConfirmation = false
    
    init(userStore: UserStore) {
        _name = State(initialValue: userStore.name)
        _email = State(initialValue: userStore.email)
        _selectedImage = State(initialValue: userStore.profileImage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Profile Image
                    ZStack(alignment: .bottomTrailing) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            showingImageOptions = true
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .offset(x: 5, y: 5)
                    }
                    .padding(.top, 20)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Enter your name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Save Button
                    Button(action: {
                        if let image = selectedImage {
                            userStore.updateProfileImage(image)
                        }
                        userStore.name = name
                        userStore.email = email
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Changes")
                        .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white))
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .actionSheet(isPresented: $showingImageOptions) {
                ActionSheet(
                    title: Text("Profile Picture"),
                    message: Text("Choose an option"),
                    buttons: [
                        .default(Text("Take Photo")) {
                            showingImagePicker = true
                        },
                        .default(Text("Choose from Library")) {
                            showingImagePicker = true
                        },
                        .destructive(Text("Remove Photo")) {
                            showingDeleteConfirmation = true
                        },
                        .cancel()
                    ]
                )
            }
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Remove Photo"),
                    message: Text("Are you sure you want to remove your profile picture?"),
                    primaryButton: .destructive(Text("Remove")) {
                        selectedImage = nil
                        userStore.removeProfileImage()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
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
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userStore: UserStore
    @State private var locationAccess = false
    @State private var weatherDataAccess = false
    @State private var dataCollection = false
    @State private var personalizedSuggestions = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                List {
                    Section(header: Text("Location & Weather").foregroundColor(.white)) {
                        Toggle(isOn: $locationAccess) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                Text("Location Access")
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.blue)
                        
                        Toggle(isOn: $weatherDataAccess) {
                            HStack {
                                Image(systemName: "cloud.sun.fill")
                                    .foregroundColor(.blue)
                                Text("Weather Data")
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.blue)
                    }
                    
                    Section(header: Text("Data & Privacy").foregroundColor(.white)) {
                        Toggle(isOn: $dataCollection) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.blue)
                                Text("Data Collection")
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.blue)
                        
                        Toggle(isOn: $personalizedSuggestions) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                Text("Personalized Suggestions")
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.blue)
                    }
                    
                    Section(header: Text("Account Data").foregroundColor(.white)) {
                        Button(action: {
                            showingDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                Text("Delete Account Data")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
            .navigationTitle("Privacy Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.white))
            .alert(isPresented: $showingDeleteConfirmation) {
                Alert(
                    title: Text("Delete Account Data"),
                    message: Text("This will permanently delete all your account data, including your wardrobe and outfit history. This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        // In a real app, implement proper data deletion
                        userStore.wardrobe.removeAll()
                        userStore.outfitHistory.removeAll()
                        userStore.profileImage = nil
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ProfileView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var showingEditProfile = false
    @State private var showingPrivacySettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Profile header
                        VStack(spacing: 20) {
                            if let profileImage = userStore.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.blue)
                            }
                            
                            Text(userStore.name.isEmpty ? "No name set" : userStore.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(userStore.email.isEmpty ? "No email set" : userStore.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .cornerRadius(10)
                        .padding(.horizontal)
                
                // Subscription section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Subscription")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                    HStack {
                        Text("Your Plan")
                                        .foregroundColor(.white)
                        Spacer()
                        Text(userStore.subscriptionTier.rawValue)
                            .fontWeight(.medium)
                                        .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Daily Outfit Suggestions")
                                        .foregroundColor(.white)
                        Spacer()
                        Text("\(userStore.subscriptionTier.outfitSuggestionsPerDay)")
                            .fontWeight(.medium)
                                        .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Price")
                                        .foregroundColor(.white)
                        Spacer()
                        Text(userStore.subscriptionTier.price)
                            .fontWeight(.medium)
                                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        // Upgrade subscription
                    }) {
                        Text(userStore.subscriptionTier == .basic ? "Upgrade to Premium" : "Manage Subscription")
                                        .modifier(AnimatedMeshGradientButton(
                                            width: UIScreen.main.bounds.width - 190,
                                            height: 30,
                                            cornerRadius: 10
                                        ))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                }
                
                // Wardrobe stats
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Wardrobe Stats")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                    HStack {
                        Text("Total Items")
                                        .foregroundColor(.white)
                        Spacer()
                        Text("\(userStore.wardrobe.count)")
                            .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                
                                HStack {
                                    Text("Saved Outfits")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(userStore.outfitHistory.count)")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        // Settings
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                    Button(action: {
                                    showingEditProfile = true
                                }) {
                                    HStack {
                                        Text("Modify Profile")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                    }
                    
                    Button(action: {
                                    showingPrivacySettings = true
                    }) {
                                    HStack {
                        Text("Privacy Settings")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                    }
                    
                    Button(action: {
                        userStore.logout()
                    }) {
                        Text("Log Out")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                    }
                }
                            .padding()
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(userStore: userStore)
            }
            .sheet(isPresented: $showingPrivacySettings) {
                PrivacySettingsView()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(UserStore())
            .preferredColorScheme(.dark)
    }
}
