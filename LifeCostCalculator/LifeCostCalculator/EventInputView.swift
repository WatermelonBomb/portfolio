//
//  EventInputView.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//


import SwiftUI

struct EventInputView: View {
    @EnvironmentObject var lifeCostviewModel: LifeCostViewModel
    
    @State private var eventName: String = ""
    @State private var eventAge: String = ""
    @State private var eventCost: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("ライフイベントを追加")) {
                TextField("イベント名（結婚/車購入など）", text: $eventName)
                TextField("発生年齢", text: $eventAge)
                    .keyboardType(.numberPad)
                TextField("イベント費用（円）", text: $eventCost)
                    .keyboardType(.decimalPad)
                
                Button(action: {
                    addEvent()
                }) {
                    Text("イベント追加")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            
            Section(header: Text("登録済みライフイベント")) {
                if lifeCostviewModel.lifeEvents.isEmpty {
                    Text("まだイベントが追加されていません")
                } else {
                    List {
                        ForEach(lifeCostviewModel.lifeEvents) { event in
                            HStack {
                                Text("\(event.name) (Age \(event.eventAge))")
                                Spacer()
                                Text("¥\(Int(event.cost))")
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    lifeCostviewModel.removeLifeEvent(event)
                                } label: {
                                    Text("削除")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("ライフイベント")
    }
    
    private func addEvent() {
        guard let age = Int(eventAge), let cost = Double(eventCost) else { return }
        let newEvent = LifeEvent(name: eventName, eventAge: age, cost: cost)
        lifeCostviewModel.addLifeEvent(newEvent)
        
        // 入力欄をクリア
        eventName = ""
        eventAge = ""
        eventCost = ""
    }
}
