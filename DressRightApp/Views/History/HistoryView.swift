// HistoryView.swift
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userStore.outfitHistory) { outfit in
                    OutfitHistoryRow(outfit: outfit)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.black)
            .navigationTitle("Outfit History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct OutfitHistoryRow: View {
    let outfit: Outfit
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateFormatter.string(from: outfit.date))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(outfit.weather.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 12)
            
            Spacer()
            
            HStack(spacing: 8) {
                Image(systemName: outfit.weather.icon)
                    .font(.system(size: 24))
                    .foregroundColor(outfit.weather.color)
            }
            .padding(.trailing, 12)
        }
        .padding(.vertical, 12)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .cornerRadius(10)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(UserStore())
            .preferredColorScheme(.dark)
    }
}
