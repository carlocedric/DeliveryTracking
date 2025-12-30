//
//  OrderManagerTests.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import XCTest
@testable import DeliveryTracking

@MainActor
final class OrderManagerTests: XCTestCase {

    // Test that updating an order changes its status correctly
    func testUpdateOrder() async {
        let manager = OrderManager(testOrders: [
            Order(id: 1, title: "Old Order", status: .pending)
        ])

        let updated = Order(id: 1, title: "Old Order", status: .delivered)
        manager.updateOrder(updated)

        // Give Combine time to propagate the @Published change
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(manager.orders.first?.status, .delivered)
    }

    // Test that loading orders appends to the manager without duplicates
    func testLoadOrdersAppendsWithoutDuplicates() async {
        class MockRepo: OrderRepository {
            func fetchOrders(filter: OrderStatus?, completion: @escaping (Result<[Order], Error>) -> Void) {
                let orders = [
                    Order(id: 1, title: "A", status: .pending),
                    Order(id: 2, title: "B", status: .delivered)
                ]
                completion(.success(orders))
            }
        }

        // Create a fresh manager for testing
        let manager = OrderManager(testOrders: [])

        let expectation = XCTestExpectation(description: "Load orders")
        
        manager.loadOrders(repository: MockRepo()) { _ in
            // Ensure orders were added correctly
            XCTAssertEqual(manager.orders.count, 2)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1)
    }
}
