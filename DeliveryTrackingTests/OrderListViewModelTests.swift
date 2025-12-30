//
//  OrderListViewModelTests.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import XCTest
@testable import DeliveryTracking

@MainActor
final class OrderListViewModelTests: XCTestCase {

    // Test that loading orders from a repository succeeds
    func testLoadOrders() async {
        class MockRepo: OrderRepository {
            func fetchOrders(filter: OrderStatus?, completion: @escaping (Result<[Order], Error>) -> Void) {
                let orders = [
                    Order(id: 1, title: "A", status: .pending),
                    Order(id: 2, title: "B", status: .delivered),
                    Order(id: 3, title: "C", status: .inTransit)
                ]
                completion(.success(orders))
            }
        }

        let viewModel = OrderListViewModel(repository: MockRepo())
        XCTAssertEqual(viewModel.state, .idle)

        viewModel.loadOrders()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.orders.count, 3)
        XCTAssertEqual(viewModel.state, .success(viewModel.orders))
    }

    // Test that filtering orders by status works correctly
    func testFilterOrders() async {
        class MockRepo: OrderRepository {
            func fetchOrders(filter: OrderStatus?, completion: @escaping (Result<[Order], Error>) -> Void) {
                let orders = [
                    Order(id: 1, title: "A", status: .pending),
                    Order(id: 2, title: "B", status: .delivered),
                    Order(id: 3, title: "C", status: .inTransit)
                ]
                completion(.success(orders))
            }
        }

        let viewModel = OrderListViewModel(repository: MockRepo())
        viewModel.loadOrders()
        try? await Task.sleep(nanoseconds: 100_000_000)

        viewModel.selectedFilter = .delivered
        XCTAssertTrue(viewModel.orders.allSatisfy { $0.status == .delivered })
        XCTAssertEqual(viewModel.orders.count, 1)
    }

    // Test that the view model correctly handles a repository failure
    func testLoadOrdersFailure() async {
        class FailingMockRepo: OrderRepository {
            func fetchOrders(filter: OrderStatus?, completion: @escaping (Result<[Order], Error>) -> Void) {
                completion(.failure(NSError(domain: "TestError", code: 1, userInfo: nil)))
            }
        }

        let viewModel = OrderListViewModel(repository: FailingMockRepo())
        XCTAssertEqual(viewModel.state, .idle)

        viewModel.loadOrders()
        try? await Task.sleep(nanoseconds: 100_000_000)

        if case .failure(let message) = viewModel.state {
            XCTAssertEqual(message, "Failed to load orders.")
        } else {
            XCTFail("Expected failure state, got \(viewModel.state)")
        }
    }
}
