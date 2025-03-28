// MainTabView.swift
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "sun.max")
                }
            
            WardrobeView()
                .tabItem {
                    Label("Wardrobe", systemImage: "tshirt")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .background(Color.black)
        .accentColor(.blue)
    }
}
