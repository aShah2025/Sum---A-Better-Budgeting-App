//
//  AnalyticsView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Query(sort: [SortDescriptor(\Transaction.date)]) private var transactions: [Transaction]
    @Query private var profiles: [UserProfile]
    
    private var profile: UserProfile? { profiles.first }
    
    private var startingBalance: Double {
        guard let profile else { return 0 }
        let net = transactions.reduce(0) { $0 + $1.amount }
        return profile.bankBalance - net
    }
    
    private var dataPoints: [BalancePoint] {
        guard let profile else { return [] }
        var running = startingBalance
        var points: [BalancePoint] = [BalancePoint(date: profile.createdAt, balance: running)]
        for tx in transactions.sorted(by: { $0.date < $1.date }) {
            running += tx.amount
            points.append(BalancePoint(date: tx.date, balance: running))
        }
        return points
    }
    
    var body: some View {
        VStack {
            GlassCard {
                VStack(alignment: .leading) {
                    Text("Balance Over Time")
                        .font(.headline)
                    if dataPoints.count <= 1 {
                        Text("No data yet. Add a transaction!")
                            .frame(height: 200)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    } else {
                        Chart(dataPoints) { point in
                            LineMark(
                                x: .value("Date", point.date, unit: .day),
                                y: .value("Balance", point.balance)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(Color.accentColor)
                            PointMark(
                                x: .value("Date", point.date, unit: .day),
                                y: .value("Balance", point.balance)
                            )
                            .annotation(position: .top) {
                                Text(formattedCurrency(point.balance))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(position: .bottom, values: .automatic) { _ in AxisGridLine(); AxisTick(); AxisValueLabel(format: .dateTime.day().month()) }
                        }
                        .chartYAxisLabel("Balance")
                        .frame(height: 220)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Analytics")
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = profile?.currency ?? Locale.current.currency?.identifier ?? "USD"
        return f.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}

struct BalancePoint: Identifiable {
    let id = UUID()
    let date: Date
    let balance: Double
}

#Preview {
    AnalyticsView()
        .modelContainer(for: [UserProfile.self, Transaction.self], inMemory: true)
}
