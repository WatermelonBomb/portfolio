//
//  SummaryView.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//

import SwiftUI
import Charts

struct SummaryView: View {
    @EnvironmentObject var lifeCostviewModel: LifeCostViewModel

    var body: some View {
        VStack {
            // 生涯推定コストの計算
            let monthlyExpenses = lifeCostviewModel.userProfile.monthlyExpenses
            let totalMonthlyExpenses = monthlyExpenses * 12.0
            let totalEventCost = lifeCostviewModel.lifeEvents.reduce(0.0) { $0 + $1.cost }
            let remainingYears = Double(lifeCostviewModel.userProfile.lifeExpectancy - lifeCostviewModel.userProfile.currentAge)
            let totalCost = (totalMonthlyExpenses * remainingYears) + totalEventCost

            Text("生涯推定コスト：\(Int(totalCost)) 円")
                .font(.title2)
                .padding(.top)

            // 必要な毎月の貯金額の計算
            let remainingMonths = remainingYears * 12.0 // 残り月数
            let savingsRequired = totalEventCost / remainingMonths // 月ごとに必要な貯金額

            if savingsRequired > 0 {
                Text("必要な毎月の貯金額：\(String(format: "%.0f", savingsRequired)) 円")
                    .font(.title3)
                    .padding(.top)
            } else {
                Text("必要な毎月の貯金額は不要です。")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding(.top)
            }

            // グラフの説明
            Text("グラフの説明")
                .font(.headline)
                .padding(.top)

            Text("青色の棒グラフは通常の年間支出を表しています。赤色の棒グラフはイベント費用を示し、それぞれの年齢で発生する追加費用を可視化します。緑色の折れ線グラフは累積貯金額の推移を示し、計画の進捗状況を把握できます。")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding([.leading, .trailing, .bottom])

            // グラフの表示
            if lifeCostviewModel.costData.isEmpty {
                Text("データがありません")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.top)
            } else {
                Chart {
                    // 年間コストの積み上げ棒グラフ
                    ForEach(lifeCostviewModel.costData, id: \ .age) { cost in
                        BarMark(
                            x: .value("年齢", cost.age),
                            y: .value("通常支出", cost.yearCost)
                        )
                        .foregroundStyle(Color.blue.gradient)

                        // イベント費用を重ねる
                        if let eventCost = lifeCostviewModel.lifeEvents.first(where: { $0.eventAge == cost.age })?.cost {
                            BarMark(
                                x: .value("年齢", cost.age),
                                y: .value("イベント費用", eventCost)
                            )
                            .foregroundStyle(Color.red.gradient)
                        }
                    }

                    // 累積貯金額の推移を線で表示
                    let cumulativeSavings = lifeCostviewModel.costData.map { $0.yearCost }.reduce(into: [Double]()) { result, cost in
                        result.append((result.last ?? 0) + cost)
                    }

                    ForEach(0..<cumulativeSavings.count, id: \ .self) { index in
                        LineMark(
                            x: .value("年齢", lifeCostviewModel.costData[index].age),
                            y: .value("貯金額", cumulativeSavings[index])
                        )
                        .foregroundStyle(Color.green.gradient)
                    }
                }
                .frame(height: 250) // グラフの高さを500に調整
                .padding()
            }

            Spacer()
        }
        .navigationTitle("結果")
    }
}
