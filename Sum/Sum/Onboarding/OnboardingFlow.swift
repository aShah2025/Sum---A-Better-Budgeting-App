//
//  OnboardingFlow.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI
import SwiftData

struct OnboardingFlow: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var hasOnboarded: Bool
    
    // Step 1: Personal Info
    @State private var name: String = ""
    @State private var birthDate: Date = Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now
    
    // Step 2: Financial Overview
    @State private var bankBalance: String = ""
    @State private var monthlyIncome: String = ""
    @State private var monthlyExpenses: String = ""
    @State private var currency: String = Locale.current.currency?.identifier ?? "USD"
    
    // Step 3: Spending Habits
    @State private var spendingHabit: SpendingHabit = .balanced
    
    // Step 4: Budgeting Style
    @State private var budgetingType: BudgetingType = .fiftyThirtyTwenty
    
    // Navigation
    @State private var currentStep: Int = 0
    private let totalSteps = 5
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            // Content
            Group {
                switch currentStep {
                case 0:
                    WelcomeStep(name: $name, birthDate: $birthDate) {
                        withAnimation { currentStep += 1 }
                    }
                    
                case 1:
                    FinancialOverviewStep(
                        bankBalance: $bankBalance,
                        monthlyIncome: $monthlyIncome,
                        monthlyExpenses: $monthlyExpenses,
                        currency: $currency
                    ) {
                        withAnimation { currentStep += 1 }
                    }
                    
                case 2:
                    SpendingHabitsStep(spendingHabit: $spendingHabit) {
                        withAnimation { currentStep += 1 }
                    }
                    
                case 3:
                    BudgetingStyleStep(budgetingType: $budgetingType) {
                        withAnimation { currentStep += 1 }
                    }
                    
                case 4:
                    GetStartedStep {
                        saveUserProfile()
                        withAnimation {
                            hasOnboarded = true
                        }
                    }
                    
                default:
                    EmptyView()
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .animation(.spring(), value: currentStep)
        }
    }
    
    private func saveUserProfile() {
        let profile = UserProfile(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDate: birthDate,
            bankBalance: Double(bankBalance) ?? 0,
            monthlyIncome: Double(monthlyIncome) ?? 0,
            monthlyExpenses: Double(monthlyExpenses) ?? 0,
            budgetingType: budgetingType,
            spendingHabit: spendingHabit,
            currency: currency
        )
        
        modelContext.insert(profile)
    }
}

#Preview {
    OnboardingFlow(hasOnboarded: .constant(false))
        .modelContainer(for: UserProfile.self, inMemory: true)
}
