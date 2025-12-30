//
//  OrderRepository.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

// Protocol defining a repository for fetching orders.
// Concrete implementations (e.g., network API or mock data) will conform to this.
protocol OrderRepository {
    /// Fetches orders, optionally filtered by status.
    /// - Parameters:
    ///   - filter: Optional status filter.
    ///   - completion: Completion handler with result containing orders or error.
    func fetchOrders(
        filter: OrderStatus?,
        completion: @escaping (Result<[Order], Error>) -> Void
    )
}
