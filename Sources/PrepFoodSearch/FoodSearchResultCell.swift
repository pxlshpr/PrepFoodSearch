import SwiftUI
import SwiftHaptics
import SwiftUISugar
import PrepUnits

struct MacrosBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let carb, fat, protein: Double
    
    init(_ searchResult: FoodSearchResult) {
        self.carb = searchResult.carb
        self.fat = searchResult.fat
        self.protein = searchResult.protein
    }
    
    let width: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 0) {
            if totalEnergy == 0 {
                Color.clear
                    .background(Color(.quaternaryLabel).gradient)
            } else {
                Color.clear
                    .frame(width: carbWidth)
                    .background(Macro.carb.fillColor(for: colorScheme).gradient)
                Color.clear
                    .frame(width: fatWidth)
                    .background(Macro.fat.fillColor(for: colorScheme).gradient)
                Color.clear
                    .frame(width: proteinWidth)
                    .background(Macro.protein.fillColor(for: colorScheme).gradient)
            }
        }
        .frame(width: width, height: 10)
        .cornerRadius(2)
        .shadow(radius: 1.5, x: 0, y: 1.5)
    }
    
    var totalEnergy: CGFloat {
        (carb * KcalsPerGramOfCarb) + (protein * KcalsPerGramOfProtein) + (fat * KcalsPerGramOfFat)
    }
    var carbWidth: CGFloat {
        guard totalEnergy != 0 else { return 0 }
        return ((carb * KcalsPerGramOfCarb) / totalEnergy) * width
    }
    
    var proteinWidth: CGFloat {
        guard totalEnergy != 0 else { return 0 }
        return ((protein * KcalsPerGramOfProtein) / totalEnergy) * width
    }
    
    var fatWidth: CGFloat {
        guard totalEnergy != 0 else { return 0 }
        return ((fat * KcalsPerGramOfFat) / totalEnergy) * width
    }
}

struct FoodSearchResultCell: View {
    
    let searchResult: FoodSearchResult
    
    var body: some View {
        HStack {
            emojiText
            nameTexts
                .multilineTextAlignment(.leading)
            Spacer()
            macrosBar
        }
        .listRowBackground(listRowBackground)
    }
    
    var macrosBar: some View {
        MacrosBar(searchResult)
    }
    
    var listRowBackgroundColor: Color {
        Color(.secondarySystemGroupedBackground)
    }
    
    var listRowBackground: some View {
        Color.white
            .colorMultiply(listRowBackgroundColor)
    }
    
    var emojiText: some View {
        Text(searchResult.emoji)
            .font(.body)
    }
    
    var nameTexts: some View {
        var view = Text(searchResult.name)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
        if let detail = searchResult.detail, !detail.isEmpty {
            view = view
            + Text(", ")
                .font(.callout)
                .foregroundColor(.secondary)
            + Text(detail)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        if let brand = searchResult.brand, !brand.isEmpty {
            view = view
            + Text(", ")
                .font(.callout)
                .foregroundColor(Color(.tertiaryLabel))
            + Text(brand)
                .font(.callout)
                .foregroundColor(Color(.tertiaryLabel))
        }
        
        return view
            .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                dimensions[.leading]
            }
    }
}


struct FoodSearchResultCellPreview: View {
    
    var body: some View {
        NavigationView {
            List {
                FoodSearchResultCell(searchResult: .init(
                    id: UUID(),
                    name: "Gold Emblem",
                    emoji: "🍬",
                    detail: "Fruit Flavored Snacks!, Green Apple, Grape, Black Cherry, Orange, Green Apple, Grape, Black Cherry, Orange",
                    brand: "Cvs Pharmacy, Inc.",
                    carb: 45,
                    fat: 2,
                    protein: 1
                ))
                FoodSearchResultCell(searchResult: .init(
                    id: UUID(),
                    name: "Golden Beer Battered White Meat Chicken Strip Shaped Patties With Mashed Potatoes And Mixed Vegetables - Includes A Chocolate Brownie",
                    emoji: "🍗",
                    detail: "Beer Battered Chicken",
                    brand: "Campbell Soup Company",
                    carb: 25,
                    fat: 6,
                    protein: 45
                ))
                FoodSearchResultCell(searchResult: .init(
                    id: UUID(),
                    name: "Golden Brown All Natural Pork Sausage Patties",
                    emoji: "🐷",
                    detail: "Mild, Minimum 18 Patties/Bag, 28 Oz.",
                    brand: "Jones Dairy Farm",
                    carb: 4,
                    fat: 36,
                    protein: 22
                ))
                FoodSearchResultCell(searchResult: .init(
                    id: UUID(),
                    name: "Banana",
                    emoji: "🍌",
                    detail: "Cavendish, peeled",
                    carb: 4,
                    fat: 36,
                    protein: 22
                ))

            }
        }
    }
}

struct FoodSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        FoodSearchResultCellPreview()
    }
}
