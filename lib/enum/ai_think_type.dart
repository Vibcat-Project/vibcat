enum AIThinkType {
  none(plainName: 'noThink'),
  auto(plainName: 'autoThink'),
  low(plainName: 'lowThink'),
  medium(plainName: 'mediumThink'),
  high(plainName: 'highThink');

  final String plainName;

  const AIThinkType({required this.plainName});
}
