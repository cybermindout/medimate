import 'package:hive/hive.dart';
part 'special_model.g.dart';

@HiveType(typeId: 2)
class SpecialModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String spec;

  @HiveField(2)
  String photo;

  SpecialModel({required this.spec, required this.photo, this.id});
}
