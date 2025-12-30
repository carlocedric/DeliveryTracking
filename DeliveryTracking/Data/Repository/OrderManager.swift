//
//  OrderManager.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import Combine
import SwiftUI

@MainActor
final class OrderManager: ObservableObject {
    static let shared = OrderManager()

    @Published private(set) var orders: [Order] = []

    private init() {}
    
    // Test initializer
    init(testOrders: [Order]) {
        self.orders = testOrders
    }

    // Loads orders from a repository, optionally filtered
    func loadOrders(repository: OrderRepository, filter: OrderStatus? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.fetchOrders(filter: filter) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let fetchedOrders):
                for order in fetchedOrders {
                    if !self.orders.contains(where: { $0.id == order.id }) {
                        self.orders.append(order)
                    }
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // Updates an existing order in the array
    func updateOrder(_ updatedOrder: Order) {
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
        }
    }
}
