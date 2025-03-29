// MainTabView.swift
import SwiftUI

struct CustomTabBarHeight: ViewModifier {
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithDefaultBackground()
                tabBarAppearance.backgroundColor = .black
                
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().frame.size.height = height
            }
    }
}

extension View {
    func customTabBarHeight(_ height: CGFloat) -> some View {
        self.modifier(CustomTabBarHeight(height: height))
    }
}

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
        .customTabBarHeight(80) // Adjust this value to change tab bar height
    }
}

// Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(UserStore())
    }
}
