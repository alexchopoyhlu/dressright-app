// DressRightApp.swift
import SwiftUI

@main
struct DressRightApp: App {
    @StateObject private var userStore = UserStore()
    
    var body: some Scene {
        WindowGroup {
            if userStore.isLoggedIn {
                MainTabView()
                    .environmentObject(userStore)
            } else {
                OnboardingView()
                    .environmentObject(userStore)
            }
        }
    }
}
