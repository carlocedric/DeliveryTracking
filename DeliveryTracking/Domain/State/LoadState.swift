//
//  LoadState.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

// Represents the current loading state of a data request
enum LoadState<T: Equatable>: Equatable {
    case idle
    case loading
    case empty
    case success(T)
    case failure(String)
}

