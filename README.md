# anvibration

Awesome Notification with hard vibration pattern



https://github.com/user-attachments/assets/52e2e71c-ba0e-41ef-9510-e3581ba7b7d5



## Problem Statement
When received a notification from FCM with data. In the data a key is defined as the notification vibration level. Then in the mobile when received notification in background or foreground then notification will appear with vibration preset pattern.

## Dependency packages:
- awesome_notifications
- firebase_messaging
- vibration

## Configuration
First configure the firebase in the project with android configuration steps. Then also configure awesome notifications.

## Tricky parts
For Foreground messaging listen stream, we need to use `FirebaseMessaging.onMessage.listen` and for the Background messaging listen service we need to use `FirebaseMessaging.onBackgroundMessage` 

```dart
FirebaseMessaging.onMessage.listen(onMessageHandeler);

FirebaseMessaging.onBackgroundMessage(onMessageHandeler);
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
