import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
  print(message.data);
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _initLocalNotification();
    try {
      final token = await _messaging.getToken();
      print('==============================');
      print('FCM TOKEN:');
      print(token);
      print('==============================');
    } catch (e) {
      print('FCM token not ready: $e');
    }

    await _messaging.subscribeToTopic('demo');
    print('Subscribed to topic: demo');

    FirebaseMessaging.onMessage.listen(_onMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification tapped (from background)');
      print(message.data);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Notification tapped (from terminated)');
      print(initialMessage.data);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('NEW FCM TOKEN: $newToken');
    });
  }

  Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Local notification tapped');
        print(details.payload);
      },
    );
  }

  /// Foreground message handler
  Future<void> _onMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final imageUrl =
        message.data['image'] ??
        message.data['imageUrl'] ??
        message.data['image_url'] ??
        notification.android?.imageUrl ??
        notification.apple?.imageUrl;

    print('DATA = ${message.data}');
    print('IMAGE URL = $imageUrl');

    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));

        bigPictureStyle = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(response.bodyBytes),
          hideExpandedLargeIcon: true,
        );
      } catch (e) {
        print('Failed load notification image: $e');
      }
    }

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyle,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }
}
