import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/Models/Todo.dart';

class TodoProvider with ChangeNotifier {
  final User? user;
  final CollectionReference todosRef;

  TodoProvider(this.user)
      : todosRef =
            FirebaseFirestore.instance.collection('todos/${user?.uid}/tasks');

  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> fetchTodos() async {
    final querySnapshot = await todosRef.get();
    _todos = querySnapshot.docs
        .map((doc) => Todo(
              id: doc.id,
              taskName: doc['taskName'],
              description: doc['description'],
              date: doc['date'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await todosRef.add({
      'taskName': todo.taskName,
      'description': todo.description,
      'date': todo.date,
    });
    fetchTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await todosRef.doc(todo.id).update({
      'taskName': todo.taskName,
      'description': todo.description,
      'date': todo.date,
    });
    fetchTodos();
  }

  Future<void> deleteTodo(String id) async {
    await todosRef.doc(id).delete();
    fetchTodos();
  }
}
