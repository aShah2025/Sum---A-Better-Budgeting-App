//
//  MainTabView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AIAssistantView()
                .tabItem {
                    Label("AI", systemImage: "brain.head.profile")
                }

            TipsView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb")
                }

            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
                }
        }
        .tint(.accentColor)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    MainTabView()
}
