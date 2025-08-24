import 'package:isar/isar.dart';

abstract class BaseSchema {
  Id id = Isar.autoIncrement;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
