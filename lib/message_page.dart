import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/message_model.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late Box<Message> messageBox;

  @override
  void initState() {
    super.initState();
    messageBox = Hive.box<Message>('messages');
  }

  Icon _iconForType(String type) {
    switch (type) {
      case 'critical':
        return const Icon(Icons.warning_amber_rounded, color: Colors.red);
      case 'warning':
        return const Icon(Icons.report_problem, color: Colors.orange);
      default:
        return const Icon(Icons.info, color: Colors.blue);
    }
  }

  void _showDetail(Message msg) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(msg.title),
            content: Text(msg.description),
            actions: [
              TextButton(
                child: const Text('Закрыть'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сообщения')),
      body: ValueListenableBuilder(
        valueListenable: messageBox.listenable(),
        builder: (context, Box<Message> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('Нет сообщений'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final msg = box.getAt(index);
              return ListTile(
                leading: Stack(
                  children: [
                    _iconForType(msg!.type),
                    if (!msg.read)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(msg.title),
                subtitle: Text(msg.description),
                onTap: () {
                  setState(() {
                    msg.read = true;
                    msg.save();
                  });
                  _showDetail(msg);
                },
              );
            },
          );
        },
      ),
    );
  }
}
