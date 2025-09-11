extension StringExt on String {
  String renderTemplate(Map<String, String> values) {
    return replaceAllMapped(RegExp(r'{{(.*?)}}'), (match) {
      final key = match.group(1)?.trim();
      return values[key] ?? match.group(0)!;
    });
  }

  String renderTemplateRecursive(Map<String, String> values) {
    String result = this;
    final regex = RegExp(r'{{(.*?)}}');

    bool hasPlaceholder(String text) => regex.hasMatch(text);

    while (hasPlaceholder(result)) {
      result = result.replaceAllMapped(regex, (match) {
        final key = match.group(1)?.trim();
        return values[key] ?? match.group(0)!;
      });
    }

    return result;
  }
}
