import 'package:cloud_firestore/cloud_firestore.dart';
import 'todo_model.dart';

class TodoService {
  final CollectionReference _todosCollection = FirebaseFirestore.instance
      .collection('todos');

  Stream<List<Todo>> getTodos() {
    return _todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addTodo(String title, String description) async {
    await _todosCollection.add({
      'title': title,
      'description': description,
      'isCompleted': false,
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await _todosCollection.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await _todosCollection.doc(id).delete();
  }
}
