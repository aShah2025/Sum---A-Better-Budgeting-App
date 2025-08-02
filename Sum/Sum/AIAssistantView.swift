//
//  AIAssistantView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI

struct AIAssistantView: View {
    @State private var userInput: String = ""
    @State private var messages: [String] = ["👋 Hi! Tell me about your budgeting goals and I’ll offer tips."]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages, id: \.self) { msg in
                        GlassCard {
                            Text(msg)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
            }
            HStack {
                TextField("Ask the AI…", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    send()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("AI Assistant")
    }

    private func send() {
        guard !userInput.isEmpty else { return }
        messages.append("You: \(userInput)")
        // Placeholder response
        messages.append("AI: That’s a great point—remember to track your fixed expenses first!")
        userInput = ""
    }
}

#Preview {
    AIAssistantView()
}
