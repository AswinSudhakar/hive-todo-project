import 'package:flutter/material.dart';
import 'package:hiveproject/modelss/todo_model.dart';
import 'package:hiveproject/service/todo_service.dart';

//all the todo
//add todo
//edit todo
//delete todo
///mark as completed
///get all todo from hive

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  final TextEditingController _titlecntler = TextEditingController();
  final TextEditingController _desccntler = TextEditingController();

//CTRATES AN INSTANCE OF getTodos class
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  //loading all todos---fetching data from hive

  Future<void> _loadTodos() async {
    _todos = await _todoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ///trigger dialoguefor adding todo
            _show_Add_dialogue();
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('All Tasks'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: _todos.isEmpty
              ? Center(
                  child: Text("No Tasks Added"),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];

                    return Card(
                      elevation: 10,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text("${index + 1}"),
                        ),
                        onTap: () {
                          //edit dialogue
                          _show_edit_dialogue(todo, index);
                        },
                        title: Text(todo.title.toString()),
                        subtitle: Text(todo.description.toString()),
                        trailing: Container(
                          width: 85,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: todo.completed,
                                  onChanged: (value) {
                                    setState(() {
                                      //value toggle
                                      todo.completed = value!;

                                      //update hive db
                                      _todoService.updateTodo(index, todo);

                                      print('updated');
                                      setState(() {});
                                    });
                                  }),
                              IconButton(
                                  onPressed: () async {
                                    await _todoService.deleteTodo(index);
                                    _loadTodos();
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }

  Future<void> _show_Add_dialogue() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titlecntler,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  TextField(
                    controller: _desccntler,
                    decoration: const InputDecoration(hintText: 'Desciption'),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    final newTodo = Todo(
                        title: _titlecntler.text,
                        description: _desccntler.text,
                        CreatedAt: DateTime.now(),
                        completed: false);
                    await _todoService.addTodo(newTodo);
                    _titlecntler.clear();
                    _desccntler.clear();
                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: const Text('add')),
              ElevatedButton(onPressed: () {}, child: const Text('cancel')),
            ],
          );
        });
  }

  Future<void> _show_edit_dialogue(Todo todo, int index) async {
    _titlecntler.text = todo.title;
    _desccntler.text = todo.description;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titlecntler,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  TextField(
                    controller: _desccntler,
                    decoration: const InputDecoration(hintText: 'Desciption'),
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    todo.title = _titlecntler.text;
                    todo.description = _desccntler.text;
                    todo.CreatedAt = DateTime.now();

                    if (todo.completed == true) {
                      todo.completed = false;
                    }
                    await _todoService.updateTodo(index, todo);

                    _titlecntler.clear();
                    _desccntler.clear();
                    Navigator.pop(context);

                    _loadTodos();
                  },
                  child: const Text('Update')),
              ElevatedButton(onPressed: () {}, child: const Text('cancel')),
            ],
          );
        });
  }
}
