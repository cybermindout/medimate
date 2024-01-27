import 'package:hive/hive.dart';
import 'package:medimate/screens/Admin/model/doctor_model.dart';

part 'wishlist_model.g.dart';

@HiveType(typeId: 6)
class WishlistModel extends HiveObject {
  @HiveField(0)
  int? doctorId;

  @HiveField(1)
  DoctorModel? doctorDetails; // Field to store the DoctorModel

  WishlistModel({
    required this.doctorId,
    required this.doctorDetails,
  });
}
