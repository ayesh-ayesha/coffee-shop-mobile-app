# ☕ Coffee Shop Mobile App

A **full-featured Coffee Shop mobile app** built with **Flutter** following the **MVVM architecture**, integrated with **Firebase** for authentication & real-time database management, and **Stripe Sandbox** for secure payments. Designed to simulate a real-world e-commerce experience for coffee lovers, with separate **user and admin functionality**.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com/)
[![Stripe](https://img.shields.io/badge/Stripe-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com/)
[![GetX](https://img.shields.io/badge/GetX-FF4081?style=for-the-badge&logo=flutter&logoColor=white)](https://pub.dev/packages/get)

---

## 🎯 Project Highlights

- **Real-world e-commerce simulation** for coffee shops
- **Admin/User roles** with dynamic access control
- **Real-time updates** using Firebase
- **Secure payments** using Stripe Sandbox
- **MVVM & GetX** for clean architecture and state management

---

## 🛠 Features

### User:
- Browse coffee categories and flavors
- Select size and customize orders
- Add coffees to **Favorites**
- Place orders and track **Order History**
- Update delivery address
- Search for coffees instantly

### Admin:
- Switch roles between **Admin** and **User** (Admin only)
- View all orders with statuses: **Paid, Unpaid, Delivered, Pending, Processing**
- Search orders by **Order ID**
- Detailed order view and **checkout management**

### Shared:
- Dynamic **Bottom Navigation Bar** for smooth screen transitions
- Consistent and responsive **UI/UX** for both user and admin
- Firebase-powered backend for **real-time data sync**

---

## 📸 Screenshots / Demo

![SignUp Screen](screenshots/signup.jpeg)
![Login Screen](screenshots/login.jpeg)  
![Coffee Categories](screenshots/user_categories.jpeg)  
![Favorites & Orders](screenshots/favorites.jpeg)  
![Order History](screenshots/order_history.jpeg)
![Admin Dashboard](screenshots/admin_home.jpeg)  
![Order Management](screenshots/order_management_admin.jpeg)  
![Payment Flow](screenshots/payment flow.jpeg)



## 🛠 Tech Stack

- **Frontend:** Flutter & Dart
- **Architecture:** MVVM (Model-View-ViewModel)
- **State Management & Navigation:** GetX
- **Backend:** Firebase Authentication, Firestore, Realtime Database
- **Payment Integration:** Stripe Sandbox

---

## 🚀 Installation / Setup

1. Clone the repository:
```bash
git clone https://github.com/ayesh-ayesha/coffee-shop-mobile-app.git
cd coffee-shop-mobile-app
