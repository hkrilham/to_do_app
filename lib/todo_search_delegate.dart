import 'package:flutter/material.dart';

class TodoSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> todoList;
  final Function(String) onSearch;

  TodoSearchDelegate({required this.todoList, required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
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
    onSearch(query);
    return _buildTodoList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onSearch(query);
    return _buildTodoList();
  }

  Widget _buildTodoList() {
    final filtered = todoList.where((todo) {
      final title = todo['title'].toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filtered[index]['title']),
        );
      },
    );
  }
}
