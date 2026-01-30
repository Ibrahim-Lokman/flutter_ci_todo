import 'package:flutter/material.dart';
import '../../data/todo_model.dart';

class TodoItemTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;
  final Function(DismissDirection)? onDismissed;
  final ValueChanged<bool?>? onCheckboxChanged;

  const TodoItemTile({
    super.key,
    required this.todo,
    required this.onTap,
    this.onDismissed,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: todo.description.isNotEmpty ? Text(todo.description) : null,
      ),
    );
  }
}
