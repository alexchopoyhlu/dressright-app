import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @EnvironmentObject var userStore: UserStore
    @State private var currentPage = 0
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedPlan = "Standard"
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                // Welcome page
                VStack(spacing: 20) {
                    Image(systemName: "hanger")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text("Welcome to DressRight")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Your AI-powered outfit assistant")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Text("Let's help you look your best every day based on the weather and your personal style.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                }
                .tag(0)
                
                // Subscription info
                VStack(spacing: 20) {
                    Text("Choose Your Plan")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    VStack(spacing: 25) {
                        SubscriptionCard(
                            title: "Standard",
                            price: "£4.99/month",
                            features: ["1 outfit suggestion per day", "Wardrobe management", "Weather-based recommendations"],
                            isSelected: selectedPlan == "Standard",
                            onTap: { selectedPlan = "Standard" }
                        )
                        
                        SubscriptionCard(
                            title: "Premium",
                            price: "£9.99/month",
                            features: ["3 outfit suggestions per day", "Wardrobe management", "Weather-based recommendations", "Premium outfit analytics"],
                            isSelected: selectedPlan == "Premium",
                            onTap: { selectedPlan = "Premium" }
                        )
                    }
                    .padding(.horizontal)
                }
                .tag(1)
                
                // Sign up page
                VStack(spacing: 20) {
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(CustomTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    CustomPasswordField(text: $password)
                        .padding(.horizontal)
                    
                    Button(action: {
                        userStore.signup(name: name, email: email, password: password)
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Apple Sign-In Button
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Apple Sign-In Successful: \(authResults)")
                            // Handle successful sign-in
                        case .failure(let error):
                            print("Apple Sign-In Failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // For demo purposes, just log in
                            userStore.login(email: "demo@example.com", password: "password")
                        }) {
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:   .always))
            .animation(.easeInOut(duration: 0.6), value: currentPage)
            
            if currentPage < 2 {
                Button(action: {
                    withAnimation {
                        currentPage += 1
                    }
                }) {
                    Text("Next")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
            .padding()
            .background(Color.black)
    }
}

struct SubscriptionCard: View {
    let title: String
    let price: String
    let features: [String]
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
                onTap()
            }
        }) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(price)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                
                ForEach(features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(feature)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(
                Group {
                    if title == "Premium" {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(UIColor.red),
                                        Color(UIColor.blue).opacity(0.8),
                                        Color.blue.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    }
                }
                .shadow(color: isSelected ? .blue.opacity(0.3) : .gray.opacity(0.2), radius: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.025 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(10)
            .foregroundColor(.white)
            .tint(.white)
            .accentColor(.white)
            .colorScheme(.dark)
    }
}

struct CustomPasswordField: View {
    @Binding var text: String
    @State private var isPasswordVisible = false
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if isPasswordVisible {
                    TextField("Password", text: $text)
                        .textFieldStyle(CustomTextFieldStyle())
                } else {
                    SecureField("Password", text: $text)
                        .textFieldStyle(CustomTextFieldStyle())
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
        }
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
        .cornerRadius(10)
    }
}

// Add this extension to support placeholder text
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(UserStore())
    }
}
