import 'package:vibcat/enum/ai_provider_type.dart';

class ModelsConfig {
  // gradient
  static const supportThinkingControl = {
    AIProviderType.siliconFlow: {
      'Qwen/Qwen3-8B': true,
      'Qwen/Qwen3-14B': true,
      'Qwen/Qwen3-32B': true,
      'Qwen/Qwen3-30B-A3B': true,
      'Qwen/Qwen3-235B-A22B': true,
      'tencent/Hunyuan-A13B-Instruct': true,
      'zai-org/GLM-4.5V': true,
      'deepseek-ai/DeepSeek-V3.1': true,
      'Pro/deepseek-ai/DeepSeek-V3.1': true,
    },
    AIProviderType.groq: {
      'qwen/qwen3-32b': false,
      'openai/gpt-oss-20b': true,
      'openai/gpt-oss-120b': true,
    },
  };
}
