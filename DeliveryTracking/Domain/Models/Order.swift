//
//  Order.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import Foundation

// Represents an order with ID, title, and status
struct Order: Identifiable, Equatable {
    let id: Int
    let title: String
    var status: OrderStatus
}

