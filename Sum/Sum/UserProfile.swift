//
//  UserProfile.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import Foundation
import SwiftData

enum BudgetingType: String, CaseIterable, Codable {
    case fiftyThirtyTwenty = "50/30/20 Rule"
    case zeroBased = "Zero-Based Budgeting"
    case envelope = "Envelope System"
    case custom = "Custom"
}

enum SpendingHabit: String, CaseIterable, Codable {
    case saver = "Saver (I rarely spend on non-essentials)"
    case balanced = "Balanced (I save but also enjoy spending)"
    case spender = "Spender (I enjoy treating myself often)"
}

@Model
final class UserProfile {
    // Personal Info
    var name: String
    var birthDate: Date
    
    // Financial Info
    var bankBalance: Double
    var monthlyIncome: Double
    var monthlyExpenses: Double
    
    // Preferences
    var budgetingType: BudgetingType
    var spendingHabit: SpendingHabit
    var currency: String
    
    // Timestamps
    var createdAt: Date
    var lastUpdated: Date
    
    init(
        name: String = "",
        birthDate: Date = .now,
        bankBalance: Double = 0,
        monthlyIncome: Double = 0,
        monthlyExpenses: Double = 0,
        budgetingType: BudgetingType = .fiftyThirtyTwenty,
        spendingHabit: SpendingHabit = .balanced,
        currency: String = Locale.current.currency?.identifier ?? "USD"
    ) {
        self.name = name
        self.birthDate = birthDate
        self.bankBalance = bankBalance
        self.monthlyIncome = monthlyIncome
        self.monthlyExpenses = monthlyExpenses
        self.budgetingType = budgetingType
        self.spendingHabit = spendingHabit
        self.currency = currency
        self.createdAt = .now
        self.lastUpdated = .now
    }
}
