//
//  DepositsViewModel.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/13/21.
//

import Foundation
import Combine

struct DepositItem: Decodable, Encodable, RemoteURLProviding {
    var objectId = UUID()
    var depositAmount: Double = 0
    var depositDate: Date = Date()
    var depositDescription: String = ""
    
    static func makeRemoteURL() -> URL? {
        URL(string: "https://stirredverse.backendless.app/api/data/Deposits?pageSize=100")
    }
}

class DepositsViewModel: ObservableObject  {
    @Published var deposits = [DepositItem]()
    private let networkManager = NetworkManager()
    private var cancellable: AnyCancellable?

    func fetchDeposits() {
        cancellable = networkManager.download(decodingType: DepositItem.self)
            .sink(receiveCompletion: { result in
                if case .failure(let error) = result {
                    print("Download Error \(error)")
                }
            },
            receiveValue: {
                self.deposits = $0
            })
    }

    func addDeposit(_ deposit: DepositItem) {
        cancellable = networkManager.upload(data: deposit, decodingType: DepositItem.self)
            .sink(receiveCompletion: { result in
                if case .failure(let error) = result {
                    print("Upload Error \(error)")
                }
            }, receiveValue: { [weak self] depositItem in
                self?.deposits.append(depositItem)
            })
    }
}

