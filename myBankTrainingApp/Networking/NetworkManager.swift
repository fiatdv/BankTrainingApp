//
//  NetworkManager.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/16/21.
//

import Foundation
import Combine

final class NetworkManager {
    let urlSession: URLSession
    let decoder: JSONDecoder = JSONDecoder()

    /// Initialize a NetworkManager
    /// - parameter timeout: By default we set a shorter timeout because the web service can be unreliable. You can specify your own timeout.
    init(timeout: TimeInterval = TimeInterval(30)) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        self.urlSession = URLSession(configuration: config)
    }

    /// Downloads content from REST API, publishing the results.
    func download<T: Codable & RemoteURLProviding>(
        decodingType: T.Type,
        queue: DispatchQueue = .main,
        retries: Int = 0) -> AnyPublisher<[T], Error> {
        
        guard let url = T.makeRemoteURL() else {
            print("Error: download URL appears to be invalid, cannot download")
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw NetworkError.responseUnsuccessful
                }
                return $0.data
            }
            .decode(type: [T].self, decoder: decoder)
            .receive(on: queue)
            .retry(retries)
            .eraseToAnyPublisher()
    }
            
    /// Uploads content to a REST API with a POST request and publishes the response.
    func upload<PayloadType: Codable & RemoteURLProviding, ResponseType: Codable>(
        data: PayloadType,
        decodingType: ResponseType.Type,
        queue: DispatchQueue = .main) -> AnyPublisher<ResponseType, Error> {
        
        guard let url = PayloadType.makeRemoteURL() else {
            print("Error: upload URL appears to be invalid, cannot upload")
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // encode type PayloadType to JSON
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(data)
            request.httpBody = jsonData
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw NetworkError.responseUnsuccessful
                }
                return $0.data
            }
            .decode(type: ResponseType.self, decoder: decoder)
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
    
    ///  NetworkManager can return one of these download errors
    enum NetworkError: String, Error {
        case invalidURL
        case responseUnsuccessful   // i.e. not HTTP 200
        
        var localizedDescription: String {
            switch self {
            case .invalidURL: return "Invalid URL"            
            case .responseUnsuccessful: return "Request did not succeed"
            }
        }
    }
}

