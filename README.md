# Flutter Firebase Push Notification Demo

Simple Flutter project that demonstrates:

- Firebase Cloud Messaging (FCM)
- Foreground notification using flutter_local_notifications
- Big image notification (Android – expanded view)
- Topic subscription
- Notification tap handling

This project is built for demo and learning purposes (client-side only).

---

## ✨ Features

- ✅ Receive push notification from Firebase Console
- ✅ Subscribe to topic (`demo`)
- ✅ Foregound notification handler
- ✅ Big image notification (Android – expanded)
- ✅ Handle notification tap (background & terminated)
- ✅ Token refresh listener
- ✅ Clean UI (Task / Reminder demo screen)

---

## 🧱 Tech Stack

- Flutter
- Firebase Cloud Messaging
- flutter_local_notifications
- flutterfire CLI

---

## 📱 Supported Platform

- ✅ Android (fully supported)
- ⚠️ iOS
  - Push notification requires real device and APNs setup
  - Image notification is not handled in this demo for iOS

---

## 🚀 Getting Started

### 1. Clone project

```bash
git clone https://github.com/Faik-irkham/fcm_new.git
cd fcm_new
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. 🔥 Firebase Setup (Required)

### Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Login to Firebase

```bash
firebase login
```

### Generate Firebase configuration

```bash
flutterfire configure
```

### 4. Run the application

```bash
flutter run
```

🧪 Demo Use Case

This project represents a simple task / reminder application that receives push notifications with images using Firebase Cloud Messaging.
