//
//  ContentView.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/13/21.
//

import SwiftUI

struct AccountsView: View {
    var body: some View {
        Text("Accounts")
    }
}

struct TransferView: View {
    var body: some View {
        Text("Transfers")
    }
}

struct ZelleView: View {
    var body: some View {
        Text("Zelle")
    }
}

struct MenuView: View {
    var body: some View {
        Text("Menu")
    }
}

struct TabsView: View {
    var body: some View {
        TabView {
            AccountsView()
                .tabItem {
                    Label("Accounts", systemImage: "house")
                }
            
            TransferView()
                .tabItem {
                    Label("Transfers", systemImage: "arrowshape.bounce.forward")
                }
            
            ZelleView()
                .tabItem {
                    Label("Zelle", systemImage: "dollarsign.circle")
                }
            
            NavigationView {
                DepositsView()
            }
            .tabItem {
                Label("Deposits", systemImage: "square.and.arrow.down.on.square")
            }
            
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
