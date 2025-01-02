
//
//  LifeEvent.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//



import Foundation

struct LifeEvent: Identifiable, Codable {
    var id = UUID()
    var name: String
    var eventAge: Int       // 何歳の時に発生するか
    var cost: Double        // イベントコスト
}
