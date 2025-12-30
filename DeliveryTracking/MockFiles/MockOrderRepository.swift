//
//  MockOrderRepository.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

// Mock implementation of OrderRepository for testing / previews.
// Later, a NetworkOrderRepository will fetch orders from a real API.

import Foundation

final class MockOrderRepository: OrderRepository {

    enum MockError: Error { case failed }

    var shouldFail = false
    var delay: TimeInterval = 1.5

    private var orders: [Order] = (1...10).map { i in
        Order(
            id: i,
            title: "Order #\(i)",
            status: OrderStatus.allCases.randomElement()!
        )
    }

    // Simulates fetching orders asynchronously with an optional status filter.
    // Can simulate failure if `shouldFail` is true.
    func fetchOrders(
        filter: OrderStatus?,
        completion: @escaping (Result<[Order], Error>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.shouldFail {
                completion(.failure(MockError.failed))
                return
            }

            let filtered = filter == nil
                ? self.orders
                : self.orders.filter { $0.status == filter }

            completion(.success(filtered))
        }
    }

    // Updates an order in the mock dataset if it exists.
    func updateOrder(_ updatedOrder: Order) {
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
        }
    }
}
