import 'package:hive/hive.dart';
part 'location_model.g.dart';

@HiveType(typeId: 3)
class LocationModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String loc;

  LocationModel({required this.loc, this.id});
}
