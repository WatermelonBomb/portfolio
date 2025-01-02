//
//  HouseholdInputView.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//

import SwiftUI

struct HouseholdInputView: View {
    @EnvironmentObject var lifeCostviewModel: LifeCostViewModel

    @State private var monthlyIncome: String = ""
    @State private var monthlyExpenses: String = ""

    var body: some View {
        Form {
            Section(header: Text("家計情報")) {
                TextField("毎月の収入（円）", text: $monthlyIncome)
                    .keyboardType(.decimalPad)
                TextField("毎月の生活費（円）", text: $monthlyExpenses)
                    .keyboardType(.decimalPad)
              
            }
            
            Button(action: {
                saveFinancialData()
            }) {
                Text("保存")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("家計情報")
        .onAppear {
            monthlyIncome = String(format: "%.0f", lifeCostviewModel.userProfile.monthlyIncome)
            monthlyExpenses = String(format: "%.0f", lifeCostviewModel.userProfile.monthlyExpenses)
        }
    }

    private func saveFinancialData() {
        if let income = Double(monthlyIncome) {
            lifeCostviewModel.userProfile.monthlyIncome = income
        }
        if let expenses = Double(monthlyExpenses) {
            lifeCostviewModel.userProfile.monthlyExpenses = expenses
        }
    }
}
