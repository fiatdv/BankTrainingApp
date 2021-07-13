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
                    left.date > right.date
                }), id: \.id) { deposit in
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text(deposit.description)
                            .font(.subheadline)
                        HStack {
                            Text(deposit.date, style:.date)
                            Spacer()
                            Text(String(format: "$%.2f", deposit.amount))
                        }.font(.callout)
                    })
                }
            }
            Section(header: Text("Totals")) {
                HStack {
                    Spacer()
                    Text(String(format: "%i transactions for a total of $%.2f",vm.deposits.count, vm.deposits.reduce(0) { result, deposit in
                            result + deposit.amount
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
    }
}

struct DepositsView_Previews: PreviewProvider {
    static var previews: some View {
        DepositsView()
    }
}
