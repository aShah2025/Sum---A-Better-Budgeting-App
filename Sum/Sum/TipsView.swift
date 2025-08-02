//
//  TipsView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI

struct TipsView: View {
    private let tips = [
        "Pay yourself first by automating savings the moment income arrives.",
        "Track every expense for at least one month to discover spending leaks.",
        "Use the 50/30/20 rule as a simple starting budget.",
        "Review subscriptions quarterly and cancel those you don’t use.",
        "Create an emergency fund covering 3–6 months of expenses before investing aggressively."
    ]

    var body: some View {
        List {
            ForEach(tips, id: \.self) { tip in
                GlassCard {
                    Text(tip)
                        .font(.title3)
                        .padding()
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 6)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle("Tips")
    }
}

#Preview {
    TipsView()
}
