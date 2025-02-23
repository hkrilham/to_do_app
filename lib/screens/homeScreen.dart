import 'package:flutter/material.dart';
import 'package:to_do_app/helpers/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> todoList = [];
  final List<Map<String, dynamic>> filteredTodoList = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String searchQuery = '';
  bool isSearching = false;

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

  void _deleteTodoItem(int id, int index) async {
    await _dbHelper.deleteTodo(id);
    setState(() {
      todoList.removeWhere((todo) => todo['id'] == id);
      filteredTodoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('ToDo App')
            : TextField(
                onChanged: _filterTodos,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredTodoList.clear();
                  filteredTodoList.addAll(todoList);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                        _deleteTodoItem(filteredTodoList[index]['id'], index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _addTodoDialog();
        },
      ),
    );
  }

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
                        _filterTodos(searchQuery);
                      });
                      Navigator.of(context).pop();
                    } else {
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

  bool _isDuplicate(String newTodo) {
    for (var todo in todoList) {
      if (todo['title'] == newTodo) {
        return true;
      }
    }
    return false;
  }
}

class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for "$query"'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Suggestions for "$query"'),
    );
  }
}
