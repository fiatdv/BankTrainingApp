//
//  DepositsViewModel.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/13/21.
//

import Foundation

struct DepositItem {
    var id = UUID()
    var amount: Double = 0
    var date: Date = Date()
    var description: String = ""
    
}

class DepositsViewModel: ObservableObject {
    @Published var deposits: [DepositItem]
    
    init() {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        deposits = [
            DepositItem(amount: 50.99,
                        date: date,
                        description: "Zelle from John Smith for sale of items #123"),
            DepositItem(amount: 98.99,
                        date: date,
                        description: "Mobile Deposit Ref: 54321"),
            DepositItem(amount: 105.39,
                        date: date,
                        description: "Mobile Deposit Ref: 67890")
        ]
    }
}

