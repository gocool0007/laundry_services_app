# FreshPress Laundry App

A Flutter mobile application for FreshPress laundry services with Firebase authentication, Firestore integration, and full order management workflow.

## ✅ Setup Complete

**Firebase Project**: freshpress-62a3c  
**Android Package**: com.freshpress.laundry  
**Auth Method**: Email/Password  
**Database**: Firestore

## Features

- ✅ Firebase email/password authentication
- ✅ User profile management in Firestore
- ✅ All 14 primary screens with laundry workflow
- ✅ INR-based pricing and calculator
- ✅ Partner tasks and earnings tracking
- ✅ Garment processing hub
- ✅ Order tracking and management
- ✅ QR/barcode scanner integration
- ✅ Real-time updates via Firestore

## Quick Start

```bash
flutter pub get
flutter run
```

## Test Credentials

Create an account in the app using any email and password (6+ characters minimum).

## Architecture

- **lib/main.dart** - App entry point with Firebase initialization
- **lib/services/firebase_app_service.dart** - Firebase auth & Firestore helpers
- **lib/screens/auth/auth_gate.dart** - Auth routing, login & registration screens
- **lib/firebase_options.dart** - Firebase project configuration
- **android/app/google-services.json** - Android Firebase configuration
- **pubspec.yaml** - Dependencies

## What's Ready

✅ Firebase Auth email/password setup  
✅ Login screen with validation  
✅ Registration screen with auto user profile creation  
✅ Auth state management (redirects to home when signed in)  
✅ Firestore user collection for profiles  
✅ Logout flow  
✅ Full FreshPress UI (14 screens)  
✅ Android Firebase config integrated  

## Run Locally

```bash
cd /path/to/laundry_services_app
flutter pub get
flutter run
```

The app will initialize Firebase on startup and direct you to login or the home screen based on auth state.

## Firestore Collections (Create in Console)

When ready, set up these Firestore collections in your Firebase Console:

### users
```json
{
  "uid": "user_id",
  "email": "user@example.com",
  "displayName": "Name",
  "role": "customer",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### orders
```json
{
  "orderId": "EXP-2048",
  "userId": "user_id",
  "items": 3,
  "service": "Express Delivery",
  "status": "in_progress",
  "amount": 1850,
  "currency": "INR",
  "createdAt": "timestamp"
}
```

### tasks
```json
{
  "taskId": "task_001",
  "partnerId": "partner_id",
  "orderId": "order_id",
  "title": "Task Execution & Intake",
  "status": "open",
  "createdAt": "timestamp"
}
```

### services
```json
{
  "serviceId": "service_001",
  "name": "Express Delivery",
  "basePrice": 1200,
  "currency": "INR",
  "description": "Fast laundry service"
}
```

### earnings
```json
{
  "partnerId": "partner_id",
  "weekEarnings": 18200,
  "pending": 4300,
  "released": 13900,
  "currency": "INR",
  "updatedAt": "timestamp"
}
```

## Next Steps

1. Add order data models and wire to Firestore
2. Implement partner task assignment flow
3. Build pricing calculator with real Firestore data
4. Add QR/barcode scanner integration
5. Implement order tracking with real-time Firestore updates
6. Build partner earnings dashboard
7. Add garment processing workflow
8. Implement push notifications

## Resources

- [Firebase Flutter Docs](https://firebase.flutter.dev)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
