//
//  OrderDetailViewModelTests.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import XCTest
@testable import DeliveryTracking

@MainActor
final class OrderDetailViewModelTests: XCTestCase {

    // Tests that an order progresses from `.pending` → `.inTransit` → `.delivered`
    func testOrderStatusProgression() async {
        let order = Order(id: 1, title: "Test Order", status: .pending)
        let viewModel = OrderDetailViewModel(order: order)
        
        // Wait for first timer tick (~2.5s), order should move to inTransit
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        XCTAssertEqual(viewModel.order.status, .inTransit)
        
        // Wait for second timer tick (~2.5s), order should move to delivered
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        XCTAssertEqual(viewModel.order.status, .delivered)
    }
}
