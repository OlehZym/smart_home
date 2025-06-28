import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'message_page.dart';
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
  Hive.registerAdapter(my.MessageAdapter()); // <== вот тут с префиксом
  await Hive.openBox<my.Message>('messages'); // <== и тут

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await localNotificationsPlugin.initialize(initializationSettings);

  webSocketService = WebSocketService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Relay Manager',
        theme: ThemeData(useMaterial3: true),
        home: const MessagePage(),
      ),
    );
  }
}
