//
//  AnalyticsView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        VStack {
            GlassCard {
                VStack(alignment: .leading) {
                    Text("Spending Overview")
                        .font(.headline)
                    // Placeholder chart graphic
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("Chart Coming Soon").foregroundStyle(.secondary))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Analytics")
    }
}

#Preview {
    AnalyticsView()
}
