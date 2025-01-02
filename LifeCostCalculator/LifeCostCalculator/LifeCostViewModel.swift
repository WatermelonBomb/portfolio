//
//  LifeCostViewModel.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//

import SwiftUI

class LifeCostViewModel: ObservableObject {
    // MARK: - Keys
    private let userProfileKey = "UserProfileKey"
    private let lifeEventsKey = "LifeEventsKey"
    
    // MARK: - Published properties
    @Published var userProfile = UserProfile() {
        didSet {
            saveUserProfile()
            calculateCosts()
        }
    }
    
    @Published var lifeEvents: [LifeEvent] = [] {
        didSet {
            saveLifeEvents()
            calculateCosts()
        }
    }
    
    @Published var costData: [CostModel] = []
    @Published var totalCost: Double = 0.0
    @Published var requiredMonthlySavings: Double? = nil
    
    // MARK: - Init
    init() {
        loadUserProfile()
        loadLifeEvents()
        calculateCosts()
    }
    
    // MARK: - Life Event Management
    func addLifeEvent(_ event: LifeEvent) {
        lifeEvents.append(event)
    }
    
    func removeLifeEvent(_ event: LifeEvent) {
        lifeEvents.removeAll { $0.id == event.id }
    }
    
    // MARK: - Core Logic: Cost Calculation
    func calculateCosts() {
        var results: [CostModel] = []
        var runningTotal: Double = 0.0
        var totalEventCost: Double = 0.0

        // イベントコストの合計
        for event in lifeEvents {
            totalEventCost += event.cost
        }

        // 年齢ごとの費用を計算
        var baseMonthlyExpenses = userProfile.monthlyExpenses
        for age in userProfile.currentAge..<userProfile.lifeExpectancy {
            let annualCost = baseMonthlyExpenses * 12
            runningTotal += annualCost

            // 年齢ごとのコストデータを追加
            results.append(CostModel(age: age, yearCost: annualCost))

            // インフレを考慮して次年の費用を増加
           // baseMonthlyExpenses *= (1 + userProfile.inflationRate)
        }

        // 総費用の合計
        self.totalCost = runningTotal + totalEventCost

        // 必要な毎月の貯金額を計算
        let availableSavings = userProfile.monthlyIncome - userProfile.monthlyExpenses
        let yearsUntilRetirement = userProfile.retirementAge - userProfile.currentAge
        let monthsUntilRetirement = yearsUntilRetirement * 12

        if monthsUntilRetirement > 0 {
            let requiredSavingsForEvents = totalEventCost / Double(monthsUntilRetirement)
            let totalRequiredSavings = max(0, requiredSavingsForEvents - availableSavings)
            requiredMonthlySavings = totalRequiredSavings
        } else {
            requiredMonthlySavings = nil
        }

        // コストデータを更新
        self.costData = results
    }

    
    // MARK: - Persistence
    func saveUserProfile() {
        do {
            let data = try JSONEncoder().encode(userProfile)
            UserDefaults.standard.set(data, forKey: userProfileKey)
        } catch {
            print("Save userProfile error: \(error)")
        }
    }
    
    func loadUserProfile() {
        guard let data = UserDefaults.standard.data(forKey: userProfileKey) else { return }
        do {
            let decoded = try JSONDecoder().decode(UserProfile.self, from: data)
            self.userProfile = decoded
        } catch {
            print("Load userProfile error: \(error)")
        }
    }
    
    func saveLifeEvents() {
        do {
            let data = try JSONEncoder().encode(lifeEvents)
            UserDefaults.standard.set(data, forKey: lifeEventsKey)
        } catch {
            print("Save lifeEvents error: \(error)")
        }
    }
    
    func loadLifeEvents() {
        guard let data = UserDefaults.standard.data(forKey: lifeEventsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([LifeEvent].self, from: data)
            self.lifeEvents = decoded
        } catch {
            print("Load lifeEvents error: \(error)")
        }
    }
}
