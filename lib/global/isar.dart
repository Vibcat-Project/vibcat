import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/data/schema/app_config.dart';
import 'package:vibcat/data/schema/chat_message.dart';
import 'package:vibcat/data/schema/conversation.dart';

class IsarInstance {
  IsarInstance._();

  static late final Isar _instance;

  static Isar get instance => _instance;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open([
      AppConfigSchema,
      AIModelConfigSchema,
      ChatMessageSchema,
      ConversationSchema,
    ], directory: dir.path);
  }
}
