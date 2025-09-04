import 'package:vibcat/global/images.dart';

// Dart 的 enum 不能使用 GetX 的国际化，因为 enum 的字段值属于常量
enum AIProviderType {
  // OpenAI 通用协议，可用于 OpenAI, Groq, OpenRouter 等
  openAI(
    plainName: 'OpenAI',
    endPoint: 'https://api.openai.com/v1',
    icon: AppImage.providerOpenAI,
    customEndPoint: true,
    compatibleOpenAI: true,
  ),
  // azureOpenAI(
  //   plainName: 'Azure OpenAI',
  //   endPoint: '',
  //   icon: AppImage.providerAzureOpenAI,
  //   customEndPoint: true,
  // ),
  // claude(
  //   plainName: 'Claude',
  //   endPoint: 'https://api.anthropic.com',
  //   icon: AppImage.providerClaude,
  // ),
  gemini(
    plainName: 'Gemini',
    endPoint: 'https://generativelanguage.googleapis.com/v1beta/openai',
    icon: AppImage.providerGemini,
    compatibleOpenAI: true,
  ),
  deepseek(
    plainName: 'Deepseek',
    endPoint: 'https://api.deepseek.com/v1',
    icon: AppImage.providerDeepseek,
    compatibleOpenAI: true,
  ),
  siliconFlow(
    plainName: '硅基流动',
    endPoint: 'https://api.siliconflow.cn/v1',
    icon: AppImage.providerSiliconFlow,
    compatibleOpenAI: true,
  ),
  groq(
    plainName: 'Groq',
    endPoint: 'https://api.groq.com/openai/v1',
    icon: AppImage.providerGroq,
    compatibleOpenAI: true,
  ),
  openRouter(
    plainName: 'OpenRouter',
    endPoint: 'https://openrouter.ai/api/v1',
    icon: AppImage.providerOpenRouter,
    compatibleOpenAI: true,
  ),
  volcanoEngine(
    plainName: '火山引擎',
    endPoint: 'https://ark.cn-beijing.volces.com/api/v3',
    icon: AppImage.providerVolcanoEngine,
    compatibleOpenAI: true,
  ),
  ollama(
    plainName: 'Ollama',
    endPoint: 'http://localhost:11434/v1',
    icon: AppImage.providerOllama,
    customEndPoint: true,
    compatibleOpenAI: true,
  );

  final String plainName;
  final String endPoint;
  final String icon;
  final bool? customEndPoint;
  final bool? compatibleOpenAI;

  const AIProviderType({
    required this.plainName,
    required this.endPoint,
    required this.icon,
    this.customEndPoint,
    this.compatibleOpenAI,
  });
}
