import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ontap_sharedprefences/provider/setting.dart';
import 'package:ontap_sharedprefences/provider/task.dart';
import 'package:provider/provider.dart';
import 'package:ontap_sharedprefences/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'screen/home.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received message while app was in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
      );
    }
  });

  final fcmToken = await FirebaseMessaging.instance.getToken();
  // Lưu trữ fcmToken ở đây
  print('Message data: ${fcmToken}');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingProvider()),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
    ],
    child: MyApp(),
  ));
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MainApp> {
  String _message = '';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while app was in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'channel_name',
              channelDescription: 'channel_description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Received message while app was in the background!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        setState(() {
          _message =
              '${message.notification!.title}: ${message.notification!.body}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: context.watch<SettingProvider>().isDark
            ? Brightness.dark
            : Brightness.light,
      ),
      home: const Home(),
    );
  }
}
