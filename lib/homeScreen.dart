import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<String> todoList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index]), // todu name i text aha kattel
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  todoList.removeAt(index); // delete buton kanana functions
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addTodoDialoge();
        },
      ),
    );
  }

  // add todo dialog

  void _addTodoDialoge() {
    String newTodo = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Dialog'),
            content: TextField(
              onChanged: (value) {
                newTodo = value;
              },
              decoration: InputDecoration(hintText: 'Enter To-Do item'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (newTodo.isNotEmpty) {
                      setState(() {
                        todoList.add(newTodo);
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'))
            ],
          );
        });
  }
}
