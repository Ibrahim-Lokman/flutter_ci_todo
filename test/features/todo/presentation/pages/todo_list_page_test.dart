import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ci_todo/features/todo/data/todo_model.dart';
import 'package:flutter_ci_todo/features/todo/presentation/pages/todo_list_page.dart';
import 'package:flutter_ci_todo/features/todo/presentation/providers/todo_provider.dart';

import 'todo_list_page_test.mocks.dart';

@GenerateMocks([TodoProvider])
void main() {
  late MockTodoProvider mockProvider;

  setUp(() {
    mockProvider = MockTodoProvider();
  });

  Widget createWidgetUnderTest() {
    return ChangeNotifierProvider<TodoProvider>.value(
      value: mockProvider,
      child: const MaterialApp(home: TodoListPage()),
    );
  }

  testWidgets('shows loading indicator when loading', (
    WidgetTester tester,
  ) async {
    when(mockProvider.isLoading).thenReturn(true);
    when(mockProvider.error).thenReturn(null);
    when(mockProvider.todos).thenReturn([]);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows todos when loaded', (WidgetTester tester) async {
    final todos = [
      Todo(id: '1', title: 'Test Todo 1', description: 'Desc 1'),
      Todo(id: '2', title: 'Test Todo 2', description: 'Desc 2'),
    ];

    when(mockProvider.isLoading).thenReturn(false);
    when(mockProvider.error).thenReturn(null);
    when(mockProvider.todos).thenReturn(todos);

    // We need to stub listeners for ChangeNotifier since we are mocking it
    // But since we use .value provider, it might just read properties.
    // Usually Mockito mocks throw on missing stubs.

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Test Todo 1'), findsOneWidget);
    expect(find.text('Test Todo 2'), findsOneWidget);
  });
}
