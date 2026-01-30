import 'package:flutter/material.dart';
import '../../data/todo_model.dart';
import '../../data/todo_service.dart';
import '../widgets/todo_item_tile.dart';
import 'todo_edit_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoService = TodoService();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo List PRO')),
      body: StreamBuilder<List<Todo>>(
        stream: todoService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];

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
                  todoService.deleteTodo(todo.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title} deleted')),
                  );
                },
                onCheckboxChanged: (value) {
                  if (value != null) {
                    final updatedTodo = Todo(
                      id: todo.id,
                      title: todo.title,
                      description: todo.description,
                      isCompleted: value,
                    );
                    todoService.updateTodo(updatedTodo);
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
