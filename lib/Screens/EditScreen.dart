import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Models/Todo.dart';
import 'package:todo_app/Services/TodoProvider.dart';
import 'package:intl/intl.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _taskNameController;
  late TextEditingController _descriptionController;
  late TextEditingController dateController;

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.todo.taskName);
    _descriptionController =
        TextEditingController(text: widget.todo.description);
    dateController = TextEditingController(text: widget.todo.date);
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _taskNameController,
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Task Name',
                  labelText: 'Task Name',
                  filled: true,
                  fillColor: Color.fromARGB(255, 215, 210, 210),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _descriptionController,
                autofocus: false,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  labelText: 'Description',
                  filled: true,
                  fillColor: Color.fromARGB(255, 215, 210, 210),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                onTap: () async {
                  DateTime date = DateTime(1900);

                  date = (await showDatePicker(
                      builder: (context, child) => Theme(
                          data: ThemeData().copyWith(
                              colorScheme: ColorScheme.dark(
                                  primary: Color.fromARGB(255, 218, 165, 228),
                                  onPrimary: Colors.pink,
                                  surface: Color.fromARGB(255, 218, 165, 228),
                                  onSurface: Colors.black)),
                          child: child!),
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2028)))!;
                  if (date != null) {
                    print(
                        date); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(date);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement
                    dateController.text = formattedDate;
                  }
                },
                controller: dateController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  iconColor: Colors.black,
                  border: InputBorder.none,
                  hintText: 'Date',
                  filled: true,
                  fillColor: Color.fromARGB(255, 215, 210, 210),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter date';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTodo = Todo(
                      id: widget.todo.id,
                      taskName: _taskNameController.text,
                      description: _descriptionController.text,
                      date: dateController.text,
                    );
                    todoProvider.updateTodo(updatedTodo);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
