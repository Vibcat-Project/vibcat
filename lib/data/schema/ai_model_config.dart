import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:vibcat/data/schema/base.dart';

import '../../enum/ai_provider_type.dart';
import '../bean/ai_model.dart';

part 'ai_model_config.g.dart';

@collection
class AIModelConfig extends BaseSchema {
  @Enumerated(EnumType.name)
  late AIProviderType provider;

  late String endPoint;
  late String apiKey;
  late String customName;

  int tokenInput = 0;
  int tokenOutput = 0;

  // 存储 List<AIModel> 的 JSON 字符串
  @protected
  String? modelsJson;

  // runtime 层解析出的 List<AIModel>（不会存库）
  @ignore
  List<AIModel>? models;

  /// 保存前：把 models 转成 JSON
  void prepareForSave() {
    modelsJson = models == null
        ? null
        : jsonEncode(models!.map((e) => e.toJson()).toList());
  }

  /// 加载后：把 JSON 转回 models
  void loadAnyData() {
    try {
      if (modelsJson != null) {
        final List<dynamic> jsonList = jsonDecode(modelsJson!);
        models = jsonList.map((e) => AIModel.fromJson(e)).toList();
      }
    } catch (e) {
      // doNothing
    }
  }

  bool get hasModels => models?.isNotEmpty ?? false;
}

extension AiModelConfigDeepCopy on AIModelConfig {
  AIModelConfig deepCopy() {
    final copy = AIModelConfig()
      ..provider = provider
      ..endPoint = endPoint
      ..apiKey = apiKey
      ..customName = customName
      ..tokenInput = tokenInput
      ..tokenOutput = tokenOutput
      ..modelsJson = modelsJson;

    // 深拷贝 models 列表
    if (models != null) {
      copy.models = models!.map((model) => model.deepCopy()).toList();
    }

    // 拷贝 BaseSchema 的字段
    copy.id = id; // Isar Id
    copy.createdAt = DateTime.fromMillisecondsSinceEpoch(
      createdAt.millisecondsSinceEpoch,
    );
    copy.updatedAt = DateTime.fromMillisecondsSinceEpoch(
      updatedAt.millisecondsSinceEpoch,
    );

    return copy;
  }
}
