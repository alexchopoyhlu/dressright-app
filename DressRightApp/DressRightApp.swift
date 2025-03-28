import SwiftUI

@main
struct DressRightApp: App {
    @StateObject private var userStore = UserStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(userStore)
                .preferredColorScheme(.dark)
                .background(Color.black)
        }
    }
} 