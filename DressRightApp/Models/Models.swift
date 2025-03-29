// Models.swift
import Foundation
import SwiftUI

struct ClothingItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var category: ClothingCategory
    var color: String
    var imageURL: String
    var isFavorite: Bool = false
    var lastWorn: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum ClothingCategory: String, CaseIterable, Identifiable {
    case tops = "Tops"
    case bottoms = "Bottoms"
    case outerwear = "Outerwear"
    case dresses = "Dresses"
    case shoes = "Shoes"
    case accessories = "Accessories"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .tops: return "tshirt"
        case .bottoms: return "square.fill"
        case .outerwear: return "jacket"
        case .dresses: return "rectangle.fill"
        case .shoes: return "shoe.2"
        case .accessories: return "hat.cap"
        }
    }
}

struct Outfit: Identifiable {
    var id = UUID()
    var date: Date
    var top: ClothingItem?
    var bottom: ClothingItem?
    var outerwear: ClothingItem?
    var shoes: ClothingItem?
    var accessories: [ClothingItem]
    var weather: WeatherCondition
    var isAccepted: Bool = false
}

enum WeatherCondition: String, CaseIterable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case snowy = "Snowy"
    case windy = "Windy"
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .snowy: return "cloud.snow.fill"
        case .windy: return "wind"
        }
    }
    
    var color: Color {
        switch self {
        case .sunny: return .yellow
        case .cloudy: return .gray
        case .rainy: return .blue
        case .snowy: return .white
        case .windy: return .mint
        }
    }
}

enum SubscriptionTier: String {
    case basic = "Basic"
    case premium = "Premium"
    
    var outfitSuggestionsPerDay: Int {
        switch self {
        case .basic: return 1
        case .premium: return 3
        }
    }
    
    var price: String {
        switch self {
        case .basic: return "£4.99/month"
        case .premium: return "£9.99/month"
        }
    }
}
