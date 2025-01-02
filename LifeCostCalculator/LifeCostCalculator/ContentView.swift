//
//  ContentView 2.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//


import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        List {
            NavigationLink(destination: ProfileInputView()) {
                Text("1. 基本プロフィールの入力")
            }
            NavigationLink(destination: HouseholdInputView()) {
                Text("2. 生活費・家計情報の入力")
            }
            NavigationLink(destination: EventInputView()) {
                Text("3. ライフイベントの設定")
            }
            NavigationLink(destination: SummaryView()) {
                Text("4. 結果の確認（グラフ表示）")
            }
        }
        .navigationTitle("人生コスト計算")
    }
}
