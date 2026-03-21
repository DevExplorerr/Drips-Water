# 💧 Drips Water 

**A Modern, Real-time Water Delivery & Subscription Management System**

Drips Water is a high-performance, cross-platform mobile and web application built with Flutter and Firebase. Designed for the 2026 water delivery industry, it features real-time order tracking, multi-address management, and a robust Admin Control Center for seamless operations.

---

## 🚀 Key Features

### 👤 Customer Experience
* **Intuitive Ordering:** Clean, Bento-style UI for browsing products and quick checkout.
* **Address Management:** Multiple location support (Home, Office, Other) with "Smart Labels" and default settings.
* **Scheduled Deliveries:** Support for standard and scheduled delivery windows.
* **Order Tracking:** Real-time status updates from "Pending" to "Delivered."
* **Promo Engine:** Built-in discount code validation for marketing campaigns.

### 🛡️ Admin Control Center (The "Secret Room")
* **Role-Based Access:** Secure dashboard accessible only to accounts with `admin` privileges.
* **Live Order Feed:** Real-time stream of all incoming orders across the platform using Firestore Snapshots.
* **Bento Stats Grid:** At-a-glance analytics for Revenue, Pending Orders, and Dispatch status.
* **Fulfillment Logic:** One-tap order dispatching and delivery completion.

---

## 🏗️ Technical Architecture
The project follows a strict **Clean Architecture** pattern to ensure scalability and maintainability:

1.  **Repository Layer (Data):** Handles direct Firebase/Firestore communication.
2.  **Service Layer (Bridge):** Contains business logic and data transformation.
3.  **Provider Layer (State):** Manages UI state using the `provider` package and handles user interactions.
4.  **Presentation Layer (UI):** High-quality, responsive widgets with support for Mobile and Web.

---

## 🛠️ Tech Stack
* **Framework:** [Flutter](https://flutter.dev/) (3.x+)
* **Backend:** [Firebase](https://firebase.google.com/) (Auth, Firestore, Hosting)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Database Rules:** Granular Firestore Security Rules for Role-Based Access Control (RBAC).
* **UI Components:** Custom "Bento" design system, Loading animations, and `ExpansionTile` detail views.

---

## 🚦 Getting Started

### Prerequisites
* Flutter SDK (v3.19.0 or higher recommended)
* A Firebase Project

### Installation
1.  **Clone the repository**
    ```bash
    git clone [https://github.com/yourusername/drips_water.git](https://github.com/yourusername/drips_water.git)
    cd drips_water
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase**
    * Run `flutterfire configure` or manually add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).

4.  **Run the app**
    ```bash
    flutter run
    ```

---

## 🔐 Security & Roles
To enable Admin features for a specific user:
1.  Navigate to the **Firestore Console**.
2.  Locate the user's document in the `users` collection.
3.  Add a field `role: "admin"` (String).
4.  The "Admin Dashboard" button will automatically appear in that user's profile.

---

## 📝 License
Distributed under the MIT License. See `LICENSE` for more information.

---

**Developed with ❤️ for the future of hydration delivery.**
