import 'package:hive/hive.dart';
part 'feedback_model.g.dart';

@HiveType(typeId: 8)
class FeedBackModel {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String date;

  FeedBackModel(
      {required this.title,
      required this.content,
      required this.date,
      this.id});
}
