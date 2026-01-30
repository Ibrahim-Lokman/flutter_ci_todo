import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_ci_todo/features/todo/data/todo_model.dart';
import 'package:flutter_ci_todo/features/todo/data/todo_service.dart';
import 'package:flutter_ci_todo/features/todo/presentation/providers/todo_provider.dart';

import 'todo_provider_test.mocks.dart';

import 'dart:async';

@GenerateMocks([TodoService])
void main() {
  late TodoProvider provider;
  late MockTodoService mockTodoService;
  late StreamController<List<Todo>> streamController;

  setUp(() {
    mockTodoService = MockTodoService();
    streamController = StreamController<List<Todo>>();
    // Stub getTodos to return our controlled stream
    when(mockTodoService.getTodos()).thenAnswer((_) => streamController.stream);
    provider = TodoProvider(todoService: mockTodoService);
  });

  tearDown(() {
    streamController.close();
  });

  group('TodoProvider', () {
    test('initial state is empty', () {
      expect(provider.todos, isEmpty);
      expect(provider.isLoading, isTrue); // Should be true before stream emits
    });

    test('addTodo calls service', () async {
      await provider.addTodo('Test Title', 'Test Desc');
      verify(mockTodoService.addTodo('Test Title', 'Test Desc')).called(1);
    });

    test('deleteTodo calls service', () async {
      await provider.deleteTodo('123');
      verify(mockTodoService.deleteTodo('123')).called(1);
    });

    test('loadTodos updates state from stream', () async {
      final todo = Todo(id: '1', title: 'Test', description: 'Desc');

      // Emit value
      streamController.add([todo]);

      // Wait for stream listener to process
      await Future.delayed(Duration.zero);

      expect(provider.todos.length, 1);
      expect(provider.todos.first.title, 'Test');
      expect(provider.isLoading, isFalse);
    });
  });
}
