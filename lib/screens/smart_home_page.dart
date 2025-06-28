import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home/screens/message_page.dart';
import 'package:smart_home/screens/password_page.dart';
import 'package:logger/logger.dart';

class SmartHomePage extends StatefulWidget {
  final int passwordCorrect;
  const SmartHomePage({super.key, required this.passwordCorrect});

  @override
  State<SmartHomePage> createState() => _SmartHomePageState();
}

class _SmartHomePageState extends State<SmartHomePage> {
  final String esp32Ip = "192.168.0.121:8080";
  final logger = Logger();

  @override
  void initState() {
    super.initState();

    if (widget.passwordCorrect != 1) {
      // Навигация в экран пароля
      Future.microtask(() {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PasswordPage()),
        );
      });
    }
  }

  Future<void> _sendCommand(String command, BuildContext context) async {
    try {
      final url = "http://$esp32Ip/${command}_wifi";
      logger.i("Отправка запроса: $url");

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 3));

      logger.i(
        "Ответ от ESP32: ${response.statusCode}, тело: ${response.body}",
      );

      if (response.statusCode == 200) {
        String message = (command == "open") ? 'Сейф открыт' : 'Сейф закрыт';
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(milliseconds: 500),
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: код ${response.statusCode}'),
            duration: const Duration(milliseconds: 1000),
          ),
        );
      }
    } catch (e) {
      logger.e("Ошибка запроса: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _goToNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.passwordCorrect != 1) {
      return const Scaffold(); // Пустой экран на время перехода
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Открыть сейф'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _goToNotifications(context),
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF06AF00), Color(0xFF76FF72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _sendCommand("open", context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
                icon: const Icon(Icons.lock_open),
                label: const Text(
                  'Открыть сейф',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _sendCommand("close", context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60),
                ),
                icon: const Icon(Icons.lock_outline),
                label: const Text(
                  'Закрыть сейф',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
