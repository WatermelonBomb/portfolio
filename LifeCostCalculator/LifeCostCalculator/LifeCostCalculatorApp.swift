import SwiftUI

@main
struct LifeCostCalculatorApp: App {
    @StateObject private var lifeCostviewModel = LifeCostViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    
            }
            .environmentObject(lifeCostviewModel)
        }
    }
}
