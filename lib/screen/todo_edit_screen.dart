import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sql_todo_app/database/todo_bloc.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import '../model/todo_model.dart';

//TODOの登録画面と編集画面をになっている。
class TodoEditScreen extends StatelessWidget {
  final DateFormat _format = DateFormat("yyyy/MM/dd HH:mm");
  final TodoBloc? todoBloc;
  final Todo todo;
  final Todo _newTodo = Todo.newTodo();

  TodoEditScreen({
    Key? key,
    this.todoBloc,
    required this.todo,
  }) : super(key: key) {
    //初期値
    _newTodo.id = todo.id;
    _newTodo.title = todo.title;
    _newTodo.dueDate = todo.dueDate;
    _newTodo.note = todo.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(''),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _titleTextFormField(),
            _dueDateTimeFormField(),
            _noteTextFormField(),
            _confirmButton(context)
          ],
        ),
      ),
    );
  }

  Widget _titleTextFormField() => TextFormField(
        decoration: const InputDecoration(labelText: "タイトル"),
        //初期の値
        initialValue: _newTodo.title,
        //変更を常に知らせる。
        onChanged: _setTitle,
      );

  void _setTitle(String title) {
    _newTodo.title = title;
  }

  Widget _dueDateTimeFormField() => DateTimeField(
        format: _format,
        decoration: const InputDecoration(labelText: "締切日"),
        initialValue: _newTodo.dueDate ?? DateTime.now(),
        onChanged: _setDueDate,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      );

  void _setDueDate(DateTime? dt) {
    _newTodo.dueDate = dt;
  }

  Widget _noteTextFormField() => TextFormField(
        decoration: const InputDecoration(labelText: "メモ"),
        initialValue: _newTodo.note,
        maxLines: 3,
        onChanged: _setNote,
      );

  void _setNote(String note) {
    _newTodo.note = note;
  }

  Widget _confirmButton(BuildContext context) => SizedBox(
        width: 100,
        height: 100,
        child: RaisedButton.icon(
          icon: const Icon(
            Icons.tag_faces,
            color: Colors.white,
          ),
          label: const Text('決定'),
          onPressed: () {
            //id で管理をする。
            if (_newTodo.id == null) {
              todoBloc?.create(_newTodo);
            } else {
              todoBloc?.update(_newTodo);
            }
            Navigator.of(context).pop();
          },
          shape: const StadiumBorder(),
          color: Colors.green,
          textColor: Colors.white,
        ),
      );
}
