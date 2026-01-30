import 'package:flutter/material.dart';
import '../../data/todo_model.dart';
import '../../data/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService;
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  TodoProvider({TodoService? todoService})
    : _todoService = todoService ?? TodoService() {
    _init(); // Initialize stream listener
  }

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _init() {
    _isLoading = true;
    notifyListeners();

    _todoService.getTodos().listen(
      (todos) {
        _todos = todos;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addTodo(String title, String description) async {
    try {
      await _todoService.addTodo(title, description);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _todoService.updateTodo(todo);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _todoService.deleteTodo(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
    );
    await updateTodo(updatedTodo);
  }
}
