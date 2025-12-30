//
//  OrderStatus.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import Foundation
import SwiftUI

// Represents the status of an order and provides a color for UI
enum OrderStatus: String, CaseIterable, Identifiable {
    case pending = "PENDING"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"

    var id: String { rawValue }
}

extension OrderStatus {
    var color: Color {
        switch self {
        case .pending:
            Color.gray.opacity(0.3)        // light gray
        case .inTransit:
            Color.yellow.opacity(0.3)      // light yellow
        case .delivered:
            Color.green.opacity(0.3)       // light green
        }
    }
}

