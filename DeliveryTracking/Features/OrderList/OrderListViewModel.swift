//
//  OrderListViewModel.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import Combine
import SwiftUI

@MainActor
final class OrderListViewModel: ObservableObject {
    @Published var selectedFilter: OrderStatus? = nil
    @Published private(set) var state: LoadState<[Order]> = .idle

    private let manager = OrderManager.shared
    private let repository: OrderRepository

    // Initializes the ViewModel with a repository (default is mock)
    init(repository: OrderRepository = MockOrderRepository()) {
        self.repository = repository
    }

    // Returns the current list of orders filtered by the selected status
    var orders: [Order] {
        if let filter = selectedFilter {
            return manager.orders.filter { $0.status == filter }
        } else {
            return manager.orders
        }
    }

    // Loads orders from the repository, updates the state accordingly
    func loadOrders() {
        state = .loading

        manager.loadOrders(repository: repository, filter: selectedFilter) { result in
            switch result {
            case .success:
                // Update state based on whether orders exist after applying filter
                if self.manager.orders.isEmpty {
                    self.state = .empty
                } else {
                    self.state = self.orders.isEmpty ? .empty : .success(self.orders)
                }
            case .failure:
                self.state = .failure("Failed to load orders.")  // Show failure state
            }
        }
    }
}
