//
//  DepositsView.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/13/21.
//

import SwiftUI

struct DepositsView: View {
    @StateObject var vm = DepositsViewModel()
    @State private var showDepositCheck = false
    
    var body: some View {
        List {
            Section(header: Text("Deposits")) {
                ForEach(vm.deposits.sorted(by: { left, right in
                    left.depositDate > right.depositDate
                }), id: \.objectId) { deposit in
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text(deposit.depositDescription)
                            .font(.subheadline)
                        HStack {
                            Text(deposit.depositDate, style:.date)
                            Spacer()
                            Text(String(format: "$%.2f", deposit.depositAmount))
                        }.font(.callout)
                    })
                }
            }
            Section(header: Text("Totals")) {
                HStack {
                    Spacer()
                    Text(String(format: "%i transactions for a total of $%.2f",vm.deposits.count, vm.deposits.reduce(0) { result, deposit in
                            result + deposit.depositAmount
                        }
                    ))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Deposits")
        .toolbar {
            Button("Add a Deposit") {
                showDepositCheck.toggle()
            }
        }
        .sheet(isPresented: $showDepositCheck) {
            DepositTicket(vm: vm)
        }
        .onAppear() {
            vm.fetchDeposits()
        }
    }
}

struct DepositsView_Previews: PreviewProvider {
    static var previews: some View {
        DepositsView()
    }
}
