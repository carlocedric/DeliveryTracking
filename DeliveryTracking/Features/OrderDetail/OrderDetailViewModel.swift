//
//  OrderDetailViewModel.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import Combine
import SwiftUI

final class OrderDetailViewModel: ObservableObject {
    @Published private(set) var order: Order
    private var timer: Timer?

    // Initializes the ViewModel with a given order and starts simulating status updates
    init(order: Order) {
        self.order = order
        startStatusSimulation()
    }

    // Starts a repeating timer to simulate the order's status changing over time
    // - Pending → In Transit → Delivered
    // Updates the shared OrderManager with the new status
    private func startStatusSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            guard let self else { return }

            DispatchQueue.main.async {
                switch self.order.status {
                case .pending:
                    self.order.status = .inTransit
                case .inTransit:
                    self.order.status = .delivered
                case .delivered:
                    self.timer?.invalidate()  // Stop timer when delivered
                }

                // Sync updated order with shared manager
                OrderManager.shared.updateOrder(self.order)
            }
        }
    }

    // Invalidates the timer when the ViewModel is deallocated
    deinit {
        timer?.invalidate()
    }
}

