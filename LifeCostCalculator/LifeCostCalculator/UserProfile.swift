//
//  UserProfile.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//


import Foundation

struct UserProfile: Codable {
    var name: String = ""
    var currentAge: Int = 30
    var retirementAge: Int = 65
    var lifeExpectancy: Int = 85
    
    var monthlyIncome: Double = 300000       // 月の収入(円)
    var monthlyExpenses: Double = 200000    // 月の生活費(円)
}
