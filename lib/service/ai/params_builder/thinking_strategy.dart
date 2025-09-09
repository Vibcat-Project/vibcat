import 'package:vibcat/bean/chat_request.dart';

import '../../../enum/ai_provider_type.dart';
import '../../../enum/ai_think_type.dart';
import '../../../global/models.dart';

abstract class ThinkingStrategy {
  Map<String, dynamic> buildParams(ChatRequest request);

  factory ThinkingStrategy.create(AIProviderType provider) {
    switch (provider) {
      case AIProviderType.openAI:
      case AIProviderType.deepseek:
      case AIProviderType.openRouter:
      case AIProviderType.ollama:
        return OpenAIThinkingStrategy();
      case AIProviderType.groq:
        return GroqThinkingStrategy();
      case AIProviderType.siliconFlow:
        return SiliconFlowThinkingStrategy();
      case AIProviderType.gemini:
        return GeminiThinkingStrategy();
      case AIProviderType.volcanoEngine:
        return VolcanoEngineThinkingStrategy();
    }
  }
}

class OpenAIThinkingStrategy implements ThinkingStrategy {
  @override
  Map<String, dynamic> buildParams(ChatRequest request) {
    if (request.conversation.thinkType == AIThinkType.none ||
        request.conversation.thinkType == AIThinkType.auto) {
      return {};
    }

    return {'reasoning_effort': request.conversation.thinkType.name};
  }
}

class GroqThinkingStrategy implements ThinkingStrategy {
  @override
  Map<String, dynamic> buildParams(ChatRequest request) {
    final gradient = ModelsConfig
        .supportThinkingControl[AIProviderType.groq]?[request.model.id];

    if (gradient == null) return {};

    if (gradient == true) {
      return {
        'reasoning_effort':
            request.conversation.thinkType == AIThinkType.none ||
                request.conversation.thinkType == AIThinkType.auto
            ? 'medium'
            : request.conversation.thinkType.name,
      };
    } else {
      return {
        'reasoning_effort': request.conversation.thinkType == AIThinkType.none
            ? 'none'
            : 'default',
      };
    }
  }
}

class SiliconFlowThinkingStrategy implements ThinkingStrategy {
  @override
  Map<String, dynamic> buildParams(ChatRequest request) {
    final gradient = ModelsConfig
        .supportThinkingControl[AIProviderType.siliconFlow]?[request.model.id];

    if (gradient == null) return {};

    final thinkingBudget = _getThinkingBudget(request.conversation.thinkType);

    return {
      'enable_thinking': request.conversation.thinkType != AIThinkType.none,
      'thinking_budget': thinkingBudget,
    };
  }

  int _getThinkingBudget(AIThinkType thinkType) {
    switch (thinkType) {
      case AIThinkType.low:
        return 128;
      case AIThinkType.medium:
        return 16320;
      case AIThinkType.high:
        return 32768;
      default:
        return 4096;
    }
  }
}

class GeminiThinkingStrategy implements ThinkingStrategy {
  @override
  Map<String, dynamic> buildParams(ChatRequest request) {
    return {
      'extra_body': {
        'google': {
          'thinking_config': {
            'include_thoughts':
                request.conversation.thinkType != AIThinkType.none,
          },
        },
      },
    };
  }
}

class VolcanoEngineThinkingStrategy implements ThinkingStrategy {
  @override
  Map<String, dynamic> buildParams(ChatRequest request) {
    final thinkingType = _getThinkingType(request.conversation.thinkType);

    return {
      "extra_body": {
        "thinking": {"type": thinkingType},
      },
    };
  }

  String _getThinkingType(AIThinkType thinkType) {
    if (thinkType == AIThinkType.none) return 'disabled';
    if (thinkType == AIThinkType.auto) return 'auto';
    return 'enabled';
  }
}
