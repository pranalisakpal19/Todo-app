import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Models/Todo.dart';
import 'package:todo_app/Screens/AddScreen.dart';
import 'package:todo_app/Screens/EditScreen.dart';
import 'package:todo_app/Services/TodoProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos;
    User? user;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('todos/${user?.uid}/tasks')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print('Something went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              // ignore: prefer_const_constructors
              Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];

                  return Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                          color: Colors.grey[200],
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(todo.taskName),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(todo.date),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Container(
                                      width: 200,
                                      child: Text(
                                        todo.description,
                                        maxLines: 5,
                                      )),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      todoProvider.deleteTodo(todo.id);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTodoScreen(todo: todo),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          )));
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(),
            ),
          );
        },
      ),
    ));
  }
}
