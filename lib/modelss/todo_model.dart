//title
// desc
//completed
//createdatetime
import 'package:hive/hive.dart';

//this line below is a directive in dart used to specify that the content of the file are part of another file
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime CreatedAt;

  @HiveField(3)
  late bool completed;

  Todo(
      {required this.title,
      required this.description,
      required this.CreatedAt,
      required this.completed});
}
