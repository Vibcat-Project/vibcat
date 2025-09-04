enum AddOptionsType {
  image(plainName: 'addImage'),
  file(plainName: 'addFile'),
  link(plainName: 'addLink');

  final String plainName;

  const AddOptionsType({required this.plainName});
}
