import 'package:isar/isar.dart';
import 'package:vibcat/data/schema/base.dart';

import '../../enum/ai_provider_type.dart';

part 'ai_model_config.g.dart';

@collection
class AIModelConfig extends BaseCollection {
  @Enumerated(EnumType.name)
  AIProviderType provider;

  String endPoint;
  String apiKey;
  String customName;

  int tokenInput = 0;
  int tokenOutput = 0;

  AIModelConfig({
    required this.provider,
    required this.endPoint,
    required this.apiKey,
    required this.customName,
  });
}
