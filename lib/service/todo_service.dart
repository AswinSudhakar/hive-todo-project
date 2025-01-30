import 'package:hive_flutter/hive_flutter.dart';

import '../modelss/todo_model.dart';

class TodoService {
  Box<Todo>? _todobox;

  Future<void> openBox() async {
    _todobox = await Hive.openBox<Todo>('todos');
  }

  Future<void> closeBox() async {
    await _todobox!.close();
  }

//add todo

  Future<void> addTodo(Todo todo) async {
    if (_todobox == null) {
      await openBox();
    }
    await _todobox!.add(todo);
  }

  //get add todo

  Future<List<Todo>> getTodos() async {
    if (_todobox == null) {
      await openBox();
    }
    return _todobox!.values.toList();
  }

  //update

  Future<void> updateTodo(int index, Todo todo) async {
    if (_todobox == null) {
      await openBox();
    }
    await _todobox!.putAt(index, todo);
  }

  //delete

  Future<void> deleteTodo(int index) async {
    if (_todobox == null) {
      await openBox();
    }
    await _todobox!.deleteAt(index);
  }
}
