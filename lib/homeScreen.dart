import 'package:flutter/material.dart';
import 'package:to_do_app/helpers/database_helper.dart';
import 'package:to_do_app/todo_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Ensure DatabaseHelper is correctly imported and initialized
  final List<Map<String, dynamic>> todoList = [];
  final List<Map<String, dynamic>> filteredTodoList = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _dbHelper.getTodos();
    setState(() {
      todoList.addAll(todos);
      filteredTodoList.addAll(todos);
    });
  }

  void _filterTodos(String query) {
    final filtered = todoList.where((todo) {
      final title = todo['title'].toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredTodoList.clear();
      filteredTodoList.addAll(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TodoSearchDelegate(
                  todoList: todoList,
                  onSearch: _filterTodos,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTodoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                filteredTodoList[index]['title'],
                style: TextStyle(
                  decoration: filteredTodoList[index]['isChecked'] == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              leading: Checkbox(
                value: filteredTodoList[index]['isChecked'] == 1,
                onChanged: (value) {
                  setState(() {
                    filteredTodoList[index]['isChecked'] = value! ? 1 : 0;
                    _dbHelper.updateTodo(filteredTodoList[index]);
                  });
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _dbHelper.deleteTodo(filteredTodoList[index]['id']);
                    filteredTodoList.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addTodoDialog();
        },
      ),
    );
  }

  // Add todo dialog
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
                    if (newTodo.isNotEmpty && !_isDuplicate(newTodo)) {
                      setState(() {
                        final newTodoItem = {'title': newTodo, 'isChecked': 0};
                        _dbHelper.insertTodo(newTodoItem);
                        todoList.add(newTodoItem);
                        _filterTodos(searchQuery); // Update filtered list
                      });
                      Navigator.of(context).pop();
                    } else {
                      // Show an error message if the input is empty or duplicate
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('To-Do item cannot be empty or duplicate'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  // Check for duplicate To-Do items
  bool _isDuplicate(String newTodo) {
    for (var todo in todoList) {
      if (todo['title'] == newTodo) {
        return true;
      }
    }
    return false;
  }
}
