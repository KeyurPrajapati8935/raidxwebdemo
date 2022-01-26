import 'package:hive/hive.dart';
part 'news_model.g.dart';

@HiveType(typeId: 0)
class Task {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? url;

  @HiveField(4)
  String? category;

  @HiveField(5)
  bool? isBookmarked;

  Task(
      {this.id,
      this.name,
      this.description,
      this.url,
      this.category,
      this.isBookmarked});
}
