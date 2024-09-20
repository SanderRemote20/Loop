//
//  FavoriteFoodDetailView.swift
//  Loop
//
//  Created by Noah Brauner on 8/2/23.
//  Copyright © 2023 LoopKit Authors. All rights reserved.
//

import SwiftUI
import LoopKit
import HealthKit

public struct FavoriteFoodDetailView: View {
    let food: StoredFavoriteFood?
    let onFoodDelete: (StoredFavoriteFood) -> Void
    
    @State private var isConfirmingDelete = false
    
    let carbFormatter: QuantityFormatter
    let absorptionTimeFormatter: DateComponentsFormatter
    let preferredCarbUnit: HKUnit
    
    public init(food: StoredFavoriteFood?, onFoodDelete: @escaping (StoredFavoriteFood) -> Void, isConfirmingDelete: Bool = false, carbFormatter: QuantityFormatter, absorptionTimeFormatter: DateComponentsFormatter, preferredCarbUnit: HKUnit = HKUnit.gram()) {
        self.food = food
        self.onFoodDelete = onFoodDelete
        self.isConfirmingDelete = isConfirmingDelete
        self.carbFormatter = carbFormatter
        self.absorptionTimeFormatter = absorptionTimeFormatter
        self.preferredCarbUnit = preferredCarbUnit
    }
    
    public var body: some View {
        if let food {
            List {
                Section("Informasjon") {
                    VStack(spacing: 16) {
                        let rows: [(field: String, value: String)] = [
                            ("Navn", food.name),
                            ("Mengde karbo", food.carbsString(formatter: carbFormatter)),
                            ("Type mat", food.foodType),
                            ("Absorpsjonstid", food.absorptionTimeString(formatter: absorptionTimeFormatter))
                        ]
                        ForEach(rows, id: \.field) { row in
                            HStack {
                                Text(row.field)
                                    .font(.subheadline)
                                Spacer()
                                Text(row.value)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                
                Button(role: .destructive, action: { isConfirmingDelete.toggle() }) {
                    Text("Slett mat")
                        .frame(maxWidth: .infinity, alignment: .center) // Align text in center
                }
            }
            .alert(isPresented: $isConfirmingDelete) {
                Alert(
                    title: Text("Slett “\(food.name)”?"),
                    message: Text("Er du sikker på at du vil slette denne maten?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Slett"), action: { onFoodDelete(food) })
                )
            }
            .insetGroupedListStyle()
            .navigationTitle(food.title)
        }
    }
}
