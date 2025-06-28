import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_home/screens/smart_home_page.dart';
import 'websocket_service.dart';
import 'package:smart_home/models/message_model.dart' as my;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late WebSocketService webSocketService;
final AudioPlayer audioPlayer = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(my.MessageAdapter());
  await Hive.openBox<my.Message>('messages');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await localNotificationsPlugin.initialize(initializationSettings);

  webSocketService = WebSocketService();
  await webSocketService.connect(); // <== теперь асинхронно

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final int _passwordCorrect = 0;

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Smart home',
        theme: ThemeData(useMaterial3: true),
        home: SmartHomePage(passwordCorrect: _passwordCorrect),
      ),
    );
  }
}
