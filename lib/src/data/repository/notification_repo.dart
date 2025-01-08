import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parkin_assessment/src/constants/image_constant.dart';
import 'package:parkin_assessment/src/main.dart';

///Top Level channel dec.
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel_parkin_assessment',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  enableVibration: true,
);

///Top Level function to initiate firebase
Future<void> initFirebase() async {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationServices.initializeAndStartListeningNotificationEvents();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    NotificationServices.showNotification(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
    NotificationServices.showNotification(remoteMessage);
  });
}

///Class that provide notification services
class NotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  ///[getDeviceToken] returns device token
  static Future<String> getDeviceToken() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token!;
  }

  ///[initializeAndStartListeningNotificationEvents] to start listening to notif events
  static Future<void> initializeAndStartListeningNotificationEvents() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {},
    );
  }

  ///[showNotification] shows notification banner
  static void showNotification(RemoteMessage remoteMessage) async {
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;

    if (notification != null && android != null) {
      final ByteData largeIconData =
          await rootBundle.load(IMAGE_CONST.APP_LOGO);
      final Uint8List largeIconBytes = largeIconData.buffer.asUint8List();

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel_parkin_assessment',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        largeIcon: ByteArrayAndroidBitmap(largeIconBytes),
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(
            presentSound: true, presentBadge: true, presentAlert: true),
      );
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
      );
    }
  }
}
