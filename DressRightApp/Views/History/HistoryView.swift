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
            .navigationTitle("Outfit History")
            .background(Color.black)
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
            VStack(alignment: .leading) {
                Text(dateFormatter.string(from: outfit.date))
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(outfit.weather.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 0) {
                if let top = outfit.top {
                    Image(systemName: "tshirt")
                        .foregroundColor(.blue)
                }
                
                if let bottom = outfit.bottom {
                    Image(systemName: "square.fill")
                        .foregroundColor(.blue)
                }
                
                if let outerwear = outfit.outerwear {
                    Image(systemName: "seal.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
}
