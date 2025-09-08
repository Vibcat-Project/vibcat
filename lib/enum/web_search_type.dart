enum WebSearchType {
  bing(plainText: 'Bing', endPoint: 'https://www.bing.com/search?q='),
  // google(plainText: 'Google', endPoint: 'https://www.google.com/search?q='),
  tavily(plainText: 'Tavily', endPoint: 'https://api.tavily.com/search');

  final String plainText;
  final String endPoint;

  const WebSearchType({required this.plainText, required this.endPoint});
}
