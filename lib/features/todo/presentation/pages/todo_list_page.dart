import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/todo_model.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item_tile.dart';
import 'todo_edit_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List PRO')),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final todos = provider.todos;

          if (todos.isEmpty) {
            return const Center(child: Text('No todos yet. Add one!'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItemTile(
                todo: todo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoEditPage(todo: todo),
                    ),
                  );
                },
                onDismissed: (direction) {
                  provider.deleteTodo(todo.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title} deleted')),
                  );
                },
                onCheckboxChanged: (value) {
                  if (value != null) {
                    provider.toggleTodoStatus(todo);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TodoEditPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
