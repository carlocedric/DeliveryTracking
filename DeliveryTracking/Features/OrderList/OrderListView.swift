//
//  OrderListView.swift
//  DeliveryTracking
//
//  Created by Carlo Cedric Lijauco on 12/30/25.
//

import SwiftUI

// Displays a list of orders with filtering by status and navigation to order details
struct OrderListView: View {
    @StateObject private var viewModel = OrderListViewModel()
    @ObservedObject private var manager = OrderManager.shared

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Orders")
                .toolbar {
                    // Picker to filter orders by status
                    Picker("Status", selection: $viewModel.selectedFilter) {
                        Text("All").tag(OrderStatus?.none)
                        ForEach(OrderStatus.allCases) {
                            Text($0.rawValue).tag(OrderStatus?.some($0))
                        }
                    }
                    .onChange(of: viewModel.selectedFilter) { _ in
                        viewModel.loadOrders()  // Reload orders on filter change
                    }
                }
        }
        .onAppear {
            viewModel.loadOrders()  // Load orders when view appears
        }
    }

    // Dynamically shows the content based on the loading state
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")  // Show a loading indicator
        case .empty:
            Text("No orders found")     // Show when no orders are available
        case .failure(let message):
            VStack {
                Text(message)           // Show error message
                Button("Retry") { viewModel.loadOrders() }  // Retry button
            }
        case .success:
            // List of orders with navigation to detail view
            List(viewModel.orders) { order in
                NavigationLink {
                    OrderDetailView(order: order)
                } label: {
                    VStack(alignment: .leading) {
                        Text(order.title)
                        Text(order.status.rawValue)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(order.status.color)  // Color-coded by status
            }
        }
    }
}
