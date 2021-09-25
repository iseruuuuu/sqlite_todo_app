import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_todo_app/screen/todo_list_screen.dart';
import 'package:sql_todo_app/database/todo_bloc.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Provider<TodoBloc>(
        create: (context) => TodoBloc(),
        child: const TodoListScreen(),
      ),
    );
  }
}
