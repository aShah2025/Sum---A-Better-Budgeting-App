//
//  HomeView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var profiles: [UserProfile]
    
    private var profile: UserProfile? { profiles.first }
    
    private var currencyFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = profile?.currency ?? Locale.current.currency?.identifier ?? "USD"
        return f
    }
    var body: some View {
        let _ = print("Loaded profile: \(String(describing: profile))")
        ScrollView {
            VStack(spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Balance")
                            .font(.headline)
                        Text(formattedBalance)
                            .font(.largeTitle.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                GlassCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Remaining Budget")
                            .font(.headline)
                        Text(formattedRemainingBudget)
                            .font(.title2.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let profile = profile {
                    switch profile.budgetingType {
                    case .fiftyThirtyTwenty:
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("50/30/20 Allocation")
                                    .font(.headline)
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text("Needs (50%)")
                                            .font(.subheadline)
                                        Text(formattedCurrency(needsAllocation))
                                            .font(.caption.bold())
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Savings (30%)")
                                            .font(.subheadline)
                                        Text(formattedCurrency(savingsAllocation))
                                            .font(.caption.bold())
                                    }
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("Wants (20%)")
                                            .font(.subheadline)
                                        Text(formattedCurrency(wantsAllocation))
                                            .font(.caption.bold())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    default:
                        EmptyView()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
    private var formattedBalance: String {
        guard let profile else { return "--" }
        return currencyFormatter.string(from: NSNumber(value: profile.bankBalance)) ?? String(format: "%.2f", profile.bankBalance)
    }
    
    private var formattedRemainingBudget: String {
        guard let profile else { return "--" }
        let remaining = profile.monthlyIncome - profile.monthlyExpenses
        return currencyFormatter.string(from: NSNumber(value: remaining)) ?? String(format: "%.2f", remaining)
    }
    
    // MARK: - 50/30/20 Helpers
    private var needsAllocation: Double {
        guard let profile else { return 0 }
        return profile.monthlyIncome * 0.5
    }
    private var savingsAllocation: Double {
        guard let profile else { return 0 }
        return profile.monthlyIncome * 0.3
    }
    private var wantsAllocation: Double {
        guard let profile else { return 0 }
        return profile.monthlyIncome * 0.2
    }
    
    private func formattedCurrency(_ amount: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: amount)) ?? String(format: "%.2f", amount)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
