//
//  OnboardingView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Binding var hasOnboarded: Bool
    @Environment(\.modelContext) private var modelContext

    @State private var bankBalanceText: String = ""
    @State private var budgetingType: String = "50/30/20"

    private let budgetingTypes = ["50/30/20", "Zero-Based", "Envelope", "Custom"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Your Finances")) {
                    TextField("Current bank balance", text: $bankBalanceText)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Budgeting Style")) {
                    Picker("Type", selection: $budgetingType) {
                        ForEach(budgetingTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Welcome to Sum")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Continue") {
                        finish()
                    }
                    .disabled(!canContinue)
                }
            }
        }
    }

    private var canContinue: Bool {
        Double(bankBalanceText) != nil && !budgetingType.isEmpty
    }

    private func finish() {
        guard let balance = Double(bankBalanceText) else { return }
        // Create a new profile with default values for required fields
        let profile = UserProfile(
            name: "User", // Default name since we don't collect it in this simple flow
            birthDate: .now, // Default to current date
            bankBalance: balance,
            monthlyIncome: 0, // Default to 0, user can update later
            monthlyExpenses: 0, // Default to 0, user can update later
            budgetingType: .fiftyThirtyTwenty, // Default to 50/30/20
            spendingHabit: .balanced, // Default to balanced spending
            currency: Locale.current.currency?.identifier ?? "USD" // Use device's currency
        )
        modelContext.insert(profile)
        hasOnboarded = true
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, configurations: config)
    
    return OnboardingView(hasOnboarded: .constant(false))
        .modelContainer(container)
}
