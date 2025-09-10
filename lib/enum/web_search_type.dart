enum WebSearchType {
  bing(
    plainText: 'Bing',
    endPoint: 'https://www.bing.com/search?q=',
    requiredAPIKey: false,
  ),
  // google(
  //   plainText: 'Google',
  //   endPoint: 'https://www.google.com/search?q=',
  //   requiredAPIKey: false,
  // ),
  tavily(
    plainText: 'Tavily',
    endPoint: 'https://api.tavily.com/search',
    requiredAPIKey: true,
  );

  final String plainText;
  final String endPoint;
  final bool requiredAPIKey;

  const WebSearchType({
    required this.plainText,
    required this.endPoint,
    required this.requiredAPIKey,
  });
}
