import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:smart_home/models/message_model.dart' as my;
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final Box<my.Message> messageBox = Hive.box<my.Message>('messages');
  final logger = Logger();

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.121:81'));

      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data);
          final my.Message msg = my.Message(
            title: json['title'],
            description: json['description'],
            type: json['type'],
            read: false,
          );

          messageBox.add(msg);

          if (msg.type == 'critical') {
            _showCriticalNotification(msg);
            _playSiren();
          } else {
            showSimpleNotification(
              Text(msg.title),
              subtitle: Text(msg.description),
              background: msg.type == 'warning' ? Colors.orange : Colors.blue,
              leading: const Icon(Icons.notification_important),
            );
          }
        },
        onError: (error) {
          logger.e("WebSocket ошибка: $error");
        },
        onDone: () {
          logger.i("WebSocket соединение закрыто");
        },
      );
    } catch (e) {
      logger.e("Ошибка при подключении к WebSocket: $e");
    }
  }

  void _playSiren() async {
    await audioPlayer.play(AssetSource('siren.mp3'));
  }

  void stopSiren() {
    audioPlayer.stop();
  }

  void _showCriticalNotification(my.Message msg) {
    localNotificationsPlugin.show(
      0,
      msg.title,
      msg.description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'critical_channel',
          'Critical Alerts',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          enableVibration: true,
          playSound: true,
        ),
      ),
    );
  }
}
