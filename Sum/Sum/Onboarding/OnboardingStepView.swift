//
//  OnboardingStepView.swift
//  Sum
//
//  Created by Aaditya Shah on 8/1/25.
//

import SwiftUI

protocol OnboardingStep: View {
    var title: String { get }
    var subtitle: String { get }
    var progress: Double { get }
    var onContinue: () -> Void { get }
    var canContinue: Bool { get }
}

struct OnboardingStepView<Content: View>: View, OnboardingStep {
    let title: String
    let subtitle: String
    let progress: Double
    let onContinue: () -> Void
    let canContinue: Bool
    let content: () -> Content
    
    init(
        title: String,
        subtitle: String,
        progress: Double,
        onContinue: @escaping () -> Void,
        canContinue: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        self.onContinue = onContinue
        self.canContinue = canContinue
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: progress, total: 1.0)
                .tint(.accentColor)
                .padding(.bottom, 24)
            
            // Content
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.largeTitle.bold())
                    .padding(.bottom, 8)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 32)
                
                content()
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canContinue ? Color.accentColor : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(!canContinue)
                .padding(.bottom, 8)
                .animation(.easeInOut, value: canContinue)
            }
            .padding()
        }
    }
}

// MARK: - Step 1: Welcome
struct WelcomeStep: View {
    @Binding var name: String
    @Binding var birthDate: Date
    let onContinue: () -> Void
    
    private var canContinue: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        OnboardingStepView(
            title: "Welcome to Sum",
            subtitle: "Let's get to know you better to personalize your experience.",
            progress: 0.2,
            onContinue: onContinue,
            canContinue: canContinue
        ) {
            VStack(spacing: 20) {
                // Name input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Name")
                        .font(.headline)
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.name)
                        .autocapitalization(.words)
                }
                
                // Birthday picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date of Birth")
                        .font(.headline)
                    DatePicker("Birthday", selection: $birthDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                }
            }
        }
    }
}

// MARK: - Step 2: Financial Overview
struct FinancialOverviewStep: View {
    @Binding var bankBalance: String
    @Binding var monthlyIncome: String
    @Binding var monthlyExpenses: String
    @Binding var currency: String
    let onContinue: () -> Void
    
    private var canContinue: Bool {
        !bankBalance.isEmpty && !monthlyIncome.isEmpty && !monthlyExpenses.isEmpty
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var body: some View {
        OnboardingStepView(
            title: "Financial Overview",
            subtitle: "Let's understand your current financial situation.",
            progress: 0.4,
            onContinue: onContinue,
            canContinue: canContinue
        ) {
            VStack(spacing: 20) {
                // Currency Picker
                Picker("Currency", selection: $currency) {
                    ForEach(Locale.commonISOCurrencyCodes, id: \.self) { code in
                        Text("\(code) - \(Locale.current.localizedString(forCurrencyCode: code) ?? "")")
                            .tag(code)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.bottom, 8)
                
                // Bank Balance
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Bank Balance")
                        .font(.headline)
                    TextField("0.00", text: $bankBalance)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            HStack {
                                Spacer()
                                Text(currency)
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 8)
                            }
                        )
                }
                
                // Monthly Income
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Income (after tax)")
                        .font(.headline)
                    TextField("0.00", text: $monthlyIncome)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            HStack {
                                Spacer()
                                Text(currency + "/month")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 8)
                            }
                        )
                }
                
                // Monthly Expenses
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Expenses")
                        .font(.headline)
                    TextField("0.00", text: $monthlyExpenses)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            HStack {
                                Spacer()
                                Text(currency + "/month")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 8)
                            }
                        )
                }
            }
        }
    }
}

// MARK: - Step 3: Spending Habits
struct SpendingHabitsStep: View {
    @Binding var spendingHabit: SpendingHabit
    let onContinue: () -> Void
    
    var body: some View {
        OnboardingStepView(
            title: "Spending Habits",
            subtitle: "How would you describe your spending style?",
            progress: 0.6,
            onContinue: onContinue
        ) {
            VStack(spacing: 16) {
                ForEach(SpendingHabit.allCases, id: \.self) { habit in
                    Button(action: { spendingHabit = habit }) {
                        HStack {
                            Text(habit.rawValue)
                                .foregroundColor(.primary)
                            Spacer()
                            if spendingHabit == habit {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(spendingHabit == habit ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Step 4: Budgeting Style
struct BudgetingStyleStep: View {
    @Binding var budgetingType: BudgetingType
    let onContinue: () -> Void
    
    var body: some View {
        OnboardingStepView(
            title: "Budgeting Style",
            subtitle: "Choose a budgeting method that works for you.",
            progress: 0.8,
            onContinue: onContinue
        ) {
            VStack(spacing: 16) {
                ForEach(BudgetingType.allCases, id: \.self) { type in
                    VStack(alignment: .leading, spacing: 8) {
                        Button(action: { budgetingType = type }) {
                            HStack {
                                Text(type.rawValue)
                                    .font(.headline)
                                Spacer()
                                if budgetingType == type {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if type == .fiftyThirtyTwenty {
                            Text("50% needs, 30% wants, 20% savings")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if type == .zeroBased {
                            Text("Every dollar has a job")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if type == .envelope {
                            Text("Allocate cash to categories")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if type != .custom {
                            Divider()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Step 5: Get Started
struct GetStartedStep: View {
    let onGetStarted: () -> Void
    
    var body: some View {
        OnboardingStepView(
            title: "You're all set! 🎉",
            subtitle: "Let's start managing your finances the smart way.",
            progress: 1.0,
            onContinue: onGetStarted
        ) {
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 16)
                
                VStack(spacing: 16) {
                    FeatureRow(icon: "chart.pie.fill", title: "Personalized Budget", description: "Your budget is tailored to your income and spending habits.")
                    FeatureRow(icon: "bell.fill", title: "Smart Alerts", description: "Get notified about unusual spending and upcoming bills.")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Track Progress", description: "See your financial health improve over time.")
                }
                .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Helper Views
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview
#Preview {
    Group {
        WelcomeStep(
            name: .constant("John"),
            birthDate: .constant(Date()),
            onContinue: {}
        )
        
        FinancialOverviewStep(
            bankBalance: .constant("5000"),
            monthlyIncome: .constant("4000"),
            monthlyExpenses: .constant("3000"),
            currency: .constant("USD"),
            onContinue: {}
        )
        
        SpendingHabitsStep(
            spendingHabit: .constant(.balanced),
            onContinue: {}
        )
        
        BudgetingStyleStep(
            budgetingType: .constant(.fiftyThirtyTwenty),
            onContinue: {}
        )
        
        GetStartedStep(onGetStarted: {})
    }
}
