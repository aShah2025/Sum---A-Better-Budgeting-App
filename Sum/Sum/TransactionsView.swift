//
//  TransactionsView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    init() {}
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Transaction.date, order: .reverse)]) private var transactions: [Transaction] = []
    @Query private var profiles: [UserProfile] = []
    
    @State private var showingAddSheet = false

    private var profile: UserProfile? { profiles.first }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(transactions) { tx in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(tx.category)
                                .font(.headline)
                            if !tx.note.isEmpty {
                                Text(tx.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Text(formattedCurrency(tx.amount))
                            .foregroundStyle(tx.amount < 0 ? .red : .green)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTransactionSheet { amount, category, note, date in
                    addTransaction(amount: amount, category: category, note: note, date: date)
                }
                .presentationDetents([.fraction(0.45)])
            }
        }
    }
    
    private func addTransaction(amount: Double, category: String, note: String, date: Date) {
        let tx = Transaction(amount: amount, date: date, category: category, note: note)
        modelContext.insert(tx)
        
        // Update profile totals
        guard let profile else { return }
        profile.bankBalance += amount
        if amount < 0 {
            profile.monthlyExpenses += abs(amount)
        } else {
            profile.monthlyIncome += amount
        }
        profile.lastUpdated = .now
    }
    
    private func delete(at offsets: IndexSet) {
        for idx in offsets {
            let tx = transactions[idx]
            // Revert profile totals
            if let profile {
                profile.bankBalance -= tx.amount
                if tx.amount < 0 {
                    profile.monthlyExpenses -= abs(tx.amount)
                } else {
                    profile.monthlyIncome -= tx.amount
                }
                profile.lastUpdated = .now
            }
            modelContext.delete(tx)
        }
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = profile?.currency ?? Locale.current.currency?.identifier ?? "USD"
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}

// MARK: - Add Transaction Sheet

private struct AddTransactionSheet: View {
    var onSave: (Double, String, String, Date) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var amountText = ""
    @State private var category = "General"
    @State private var note = ""
    @State private var date = Date()
    
    private var amount: Double? { Double(amountText) }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Amount")) {
                    TextField("e.g. -50.25 for expense, 100 for income", text: $amountText)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Category")) {
                    TextField("Category", text: $category)
                }
                Section(header: Text("Note")) {
                    TextField("Optional note", text: $note)
                }
                Section(header: Text("Date")) {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amt = amount {
                            onSave(amt, category, note, date)
                            dismiss()
                        }
                    }
                    .disabled(amount == nil)
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
        .modelContainer(for: [UserProfile.self, Transaction.self], inMemory: true)
}
