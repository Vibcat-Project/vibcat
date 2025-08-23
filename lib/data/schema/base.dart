import 'package:isar/isar.dart';

abstract class BaseCollection {
  Id id = Isar.autoIncrement;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
