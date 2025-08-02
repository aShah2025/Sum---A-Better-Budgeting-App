//
//  Transaction.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import Foundation
import SwiftData

/// Represents a single financial transaction (expense or income).
/// Positive `amount` values are income, negative values are expenses.
@Model
final class Transaction {
    var amount: Double          // + income, - expense
    var date: Date
    var category: String
    var note: String

    init(amount: Double, date: Date = .now, category: String = "General", note: String = "") {
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
}
