import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String type; // info, warning, critical

  @HiveField(3)
  bool read;

  Message({
    required this.title,
    required this.description,
    required this.type,
    this.read = false,
  });
}
