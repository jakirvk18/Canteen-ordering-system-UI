# College Canteen Management System 🍟

A modern, cross-platform mobile application developed with **Flutter** to digitalize and streamline the food ordering process within institutional or organizational canteens. It focuses on reducing waiting times and automating order management for both students and staff.

---

## ✨ Features

### User (Student) Interface
* **Menu Browsing:** View a comprehensive list of food items with prices.
* **Dynamic Order Calculation:** Real-time calculation of the total bill as items are selected and quantities are adjusted.
* **Quantity Management:** Simple stepper controls to set the desired quantity for each item.
* **Order Confirmation:** Simulates order placement by displaying a detailed `Order Summary Screen` with a unique Order ID.

### Technical & Design
* **Platform:** Built using **Flutter** for cross-platform deployment.
* **Theming:** Utilizes a custom **Dark Theme** with a striking Deep Red (`primary`) and Bright Yellow (`secondary`) color scheme.
* **Responsive UI:** Uses `GridView` with dynamic column counts to adapt layout across mobile, tablet, and web views.
* **State Management:** Efficient local state handling (`StatefulWidget`) to manage quantities and total amount calculation.

---

## 🛠 Tech Stack

| Component | Technology | Role |
| :--- | :--- | :--- |
| **Frontend UI** | **Flutter** | Cross-platform application framework |
| **Language** | **Dart** | Core programming language |
| **Styling** | Custom Dark Theme (Material 3) | Visual design and user experience |
| **Data Simulation** | `Map<String, int>` | Local cart and quantity tracking |

---

## 🚀 Getting Started

This project requires the **Flutter SDK** and the necessary assets to run correctly.

### Prerequisites

* **Flutter SDK** (3.x or newer)
* **Dart SDK**
* A Flutter-enabled IDE (e.g., VS Code or Android Studio)

### Installation and Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/canteen-management-system.git](https://github.com/your-username/canteen-management-system.git)
    cd canteen-management-system
    ```

2.  **Download Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Asset Configuration (Crucial Step):**
    The application relies on 15 local images (e.g., `biryani.png`, `noodles.png`). To run without the "Asset Missing" error, ensure you have:
    * Created the directory: `assets/images/`
    * Placed placeholder images (named exactly as in the code, e.g., `burger.png`, `coffee.png`) inside this folder.
    * Verified the `pubspec.yaml` contains the correct asset declaration:
        ```yaml
        flutter:
          # ...
          assets:
            - assets/images/
        ```

4.  **Run the Application:**
    ```bash
    flutter run
    ```

---

## 👤 Author

* **JAKIR HUSSAIN** - *Initial Concept and Implementation*

---


