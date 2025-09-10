import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:vibcat/data/schema/ai_model_config.dart';
import 'package:vibcat/enum/web_search_type.dart';

part 'app_config.g.dart';

@collection
class AppConfig {
  static const key = 0;

  @Index()
  @protected
  final Id id = key;

  /// --------------------------------------
  // 触感反馈
  bool hapticFeedback = true;

  /// --------------------------------------
  // 话题命名模型 提供商 id
  @protected
  int? topicNamingAIProviderId;

  // 话题命名模型 id
  String? topicNamingAIProviderModelId;

  // 话题命名模型 提供商
  @ignore
  AIModelConfig? topicNamingAIProvider;

  // 话题命名模型是否可用
  @ignore
  bool get isValidTopicNamingModel =>
      topicNamingAIProvider != null && topicNamingAIProviderModelId != null;

  /// --------------------------------------
  // 默认对话模型 提供商 id
  @protected
  int? defaultConvAIProviderId;

  // 默认对话模型 id
  String? defaultConvAIProviderModelId;

  // 默认对话模型 提供商
  @ignore
  AIModelConfig? defaultConvAIProvider;

  // 默认对话模型是否可用
  @ignore
  bool get isValidDefaultConvModel =>
      defaultConvAIProvider != null && defaultConvAIProviderModelId != null;

  /// --------------------------------------
  // 新对话使用上一次的模型
  bool newConvUseLastModel = true;

  /// --------------------------------------
  // WebSearch 类型
  @Enumerated(EnumType.name)
  WebSearchType webSearchType = WebSearchType.bing;

  // WebSearch API Key
  String webSearchApiKey = "";

  void prepareForSave() {
    topicNamingAIProviderId = topicNamingAIProvider?.id;
    defaultConvAIProviderId = defaultConvAIProvider?.id;
  }

  void loadAnyData(
    AIModelConfig? topicNamingConfig,
    AIModelConfig? defaultConvConfig,
  ) {
    topicNamingAIProvider = topicNamingConfig;
    defaultConvAIProvider = defaultConvConfig;

    // 如果 AIModelConfig 未获取到，可能是用户删除了这个模型服务商，所以对应的模型也就无效了
    if (topicNamingConfig == null) {
      topicNamingAIProviderModelId = null;
    }
    if (defaultConvConfig == null) {
      defaultConvAIProviderModelId = null;
    }
  }
}
