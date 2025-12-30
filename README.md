# DeliveryTracking App

A simple SwiftUI app for tracking delivery orders with real-time status updates.

---

## Features

- Display a list of orders with filtering by status (`Pending`, `In Transit`, `Delivered`).
- Real-time status updates for each order (automatically progresses from `Pending` → `In Transit` → `Delivered`).
- Color-coded status indicators:
  - Pending: Light Gray
  - In Transit: Light Yellow
  - Delivered: Light Green
- Order detail view with a status banner.
- Supports mock repository for testing, with failure simulation.

![Screenshots](https://i.ibb.co/d4b7g0mJ/Delivery-Tracking.jpg)

---

## Architecture

- **MVVM**
  - `OrderListViewModel` handles the view logic for the list.
  - `OrderDetailViewModel` handles the status updates for a single order.
  - `OrderManager` acts as a shared store for all orders.
- **Repository pattern**
  - `OrderRepository` protocol defines how to fetch orders.
  - `MockOrderRepository` provides mock data for development and testing.
  - Can be extended later to connect to a real API.

---

## Models

- `Order`: Represents a single order.
- `OrderStatus`: Enum representing the status (`pending`, `inTransit`, `delivered`) with associated color.
- `LoadState`: Tracks loading state of async data (`idle`, `loading`, `empty`, `success`, `failure`).

---

## SwiftUI Views

- **OrderListView**: Shows the list of orders and a filter picker.
- **OrderDetailView**: Shows the details of a single order, with a banner for status.
- Color-coded banners and list backgrounds for order status.

---

## Testing

- Unit tests for:
  - `OrderListViewModel` loading, filtering, and failure handling.
  - `OrderDetailViewModel` status progression.
  - `OrderManager` updates and load logic.

---

## Future Improvements (due to time constraints or future enhabcemebts)

- Replace `MockOrderRepository` with real API calls.
- Add pull-to-refresh functionality.
- Add error messages and retry UI for failed API calls.
- Persist orders locally using Core Data or similar storage.
- Add sorting and search capabilities.
- Add automated UI Tests to verify navigation, filtering and status updates

---

### 🔹 Domain vs UI Models
- UI uses view models, not raw data.
- Keeps UI and data separate.
- Easy to update if API changes.

### 🔹 Testability by Design
- Can swap real or mock data easily.
- View models and manager centralize logic.
- Safe async updates with @MainActor.

### 🔹 Safe Evolution
- Adding new order states only needs enum and color update.
- `switch` statements handle new states.
- Tests make sure filtering and UI still work.


