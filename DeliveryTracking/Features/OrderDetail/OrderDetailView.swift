//
//  OrderDetailView.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import SwiftUI

import SwiftUI

// Displays detailed information about a single order, including its status and progress
struct OrderDetailView: View {

    @StateObject private var viewModel: OrderDetailViewModel

    init(order: Order) {
        _viewModel = StateObject(wrappedValue: OrderDetailViewModel(order: order))
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.order.title)
                .font(.title)
            
            Text(viewModel.order.status.rawValue)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(viewModel.order.status.color.opacity(0.8))
                        .clipShape(Capsule())
                        .shadow(radius: 1)

            if viewModel.order.status != .delivered {
                ProgressView("Updating status...")
            }
        }
        .padding()
        .navigationTitle("Order Details")
    }
}

