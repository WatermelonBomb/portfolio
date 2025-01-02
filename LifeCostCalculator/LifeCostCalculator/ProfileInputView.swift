//
//  ProfileInputView.swift
//  LifeCostCalculator
//
//  Created by Yuki ono on 2024/12/16.
//


import SwiftUI

struct ProfileInputView: View {
    @EnvironmentObject var LifeCostViewModel: LifeCostViewModel
    @State private var currentAge: String = ""
    @State private var retirementAge: String = ""
    @State private var lifeExpectancy: String = ""
    @State private var showErrorAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("基本プロフィール")) {
                TextField("名前(任意)", text: $LifeCostViewModel.userProfile.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("現在の年齢", text: $currentAge)
                    .keyboardType(.numberPad)
                
                TextField("リタイア年齢", text: $retirementAge)
                    .keyboardType(.numberPad)
                
                TextField("寿命（仮定）", text: $lifeExpectancy)
                    .keyboardType(.numberPad)
            }
            
            Button(action: {
                if validateInputs() {
                    LifeCostViewModel.userProfile.currentAge = Int(currentAge) ?? 30
                    LifeCostViewModel.userProfile.retirementAge = Int(retirementAge) ?? 65
                    LifeCostViewModel.userProfile.lifeExpectancy = Int(lifeExpectancy) ?? 85
                } else {
                    showErrorAlert = true
                }
            }) {
                Text("保存")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("基本プロフィール")
        .onAppear {
            // 初期値を表示
            currentAge = "\(LifeCostViewModel.userProfile.currentAge)"
            retirementAge = "\(LifeCostViewModel.userProfile.retirementAge)"
            lifeExpectancy = "\(LifeCostViewModel.userProfile.lifeExpectancy)"
        }
        .alert("入力エラー", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("年齢は0以上の数値を入れてください。")
        }
        .environmentObject(LifeCostViewModel)
        
    }
    
    private func validateInputs() -> Bool {
        guard let cAge = Int(currentAge), cAge >= 0 else { return false }
        guard let rAge = Int(retirementAge), rAge >= 0 else { return false }
        guard let lExp = Int(lifeExpectancy), lExp >= 0 else { return false }
        return true
    }
    
}
