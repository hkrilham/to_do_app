import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // To-Do List ஐ வைத்திருக்க ஒரு List<String> உருவாக்கியுள்ளோம்
  final List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'), // அப்பின் title ஐ அமைத்தல்
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index]), // To-Do name ஐ Text ஆகக் காட்டல்
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  todoList.removeAt(index); // Delete Button க்கான செயல்பாடு
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodoDialog(); // புதிய To-Do ஐ சேர்க்க Dialog function ஐப் பயன்படுத்து
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog Function To-Do ஐ சேர்
  void _addTodoDialog() {
    String newTodo = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New To-Do'),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
            decoration: const InputDecoration(hintText: 'Enter To-Do item'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTodo.isNotEmpty) {  // Empty input யை தவிர்க்கச் செய்வது
                  setState(() {
                    todoList.add(newTodo);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
