//
//  DepositItemView.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/13/21.
//

import SwiftUI

struct DepositTicket: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm:DepositsViewModel
    @State private var date = Date()
    @State private var amount = ""
    @State private var description = ""

    let total = 2.50
    var body: some View {
        NavigationView {
            Form() {
                Section {
                    DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                        Text("Date")
                            .foregroundColor(Color.gray)
                    }
                    TextField("Amount", text: $amount)
                    TextField("Description", text: $description)
                }
                Section {
                    Button("OK") {
                        presentationMode.wrappedValue.dismiss()
                        vm.addDeposit(DepositItem(depositAmount: Double(amount) ?? 0.0, depositDate: date, depositDescription: description))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("Deposit Ticket")
        }
    }
}

struct DepositItemView_Previews: PreviewProvider {
    static var previews: some View {
        DepositTicket(vm: DepositsViewModel())
    }
}
