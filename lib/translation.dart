import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'appName': 'Vibcat',
          'appSlogan': '',

          'askSomething': '要问点儿什么？',
          'search': '搜索',
          'settings': '设置',
          'modelSettings': '模型设置',
          'onlineSearch': '联网搜索',
          'chatSettings': '对话设置',
          'otherSettings': '其他设置',
          'hapticFeedback': '触感反馈',
          'addModelProvider': '添加模型服务商',
          'modelProvider': '模型服务商',
          'apiEndPoint': 'API 地址',
          'apiKey': 'API 密钥',
          'modelCustomName': '自定义名称',
          'add': '添加',
          'pleaseInput': '请输入',
          'inputToken': '输入 token',
          'outputToken': '输出 token',
          'tip': '提示',
          'option': '选项',
          'ok': '确定',
          'cancel': '取消',
          'sureToDeleteAIModelConfig': '确定要删除这个模型服务商吗？',
          'selectModels': '选择模型',

          'dataLoadFail': '数据获取失败辣！！',
        },
        'en_US': {
          'appName': 'Vibcat',
          'appSlogan': '',
        }
      };
}
