enum AIThinkType {
  auto(plainName: 'autoThink'),
  none(plainName: 'noThink'),
  low(plainName: 'lowThink'),
  medium(plainName: 'mediumThink'),
  high(plainName: 'highThink');

  final String plainName;

  const AIThinkType({required this.plainName});
}
