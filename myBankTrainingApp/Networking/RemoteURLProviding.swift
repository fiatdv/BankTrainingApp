//
//  RemoteURLProviding.swift
//  myBankTrainingApp
//
//  Created by Felipe on 7/16/21.
//
//  Protocol for a type that can provide a remote URL for its retrieval from a server

import Foundation

protocol RemoteURLProviding {
    static func makeRemoteURL() -> URL?
}
