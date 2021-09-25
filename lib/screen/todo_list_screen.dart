import 'package:flutter/material.dart';
import 'package:sql_todo_app/screen/todo_edit_screen.dart';
import 'package:sql_todo_app/database/todo_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sql_todo_app/model/todo_model.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<Todo>>(
        stream: _bloc.todoStream,
        //AsyncSnapshotとは、非同期計算との最新の相互作用の不変表現。
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Todo todo = snapshot.data![index];
                return Dismissible(
                  key: Key(todo.id!),
                  //スライドで削除できる機能　＝＞左 => 右
                  background: _backgroundOfDismissible(),
                  //スライドで削除できる機能　 => 右 => 左
                  secondaryBackground: _secondaryBackgroundOfDismissible(),
                  onDismissed: (direction) {
                    //todo_blocから削除するメソッドを呼ぶ
                    _bloc.delete(todo.id!);
                  },
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        //TODOを編集する画面を表示
                        _moveToEditView(context, _bloc, todo);
                      },
                      title: Text("${todo.title}"),
                      subtitle: Text("${todo.note}"),
                      trailing: Text(todo.dueDate!.toLocal().toString()),
                      //null以外である必要がある。
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            );
          }
          //なんでいるのかな？？　いつ使う？
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //登録画面に飛ぶ
          _moveToCreateView(context, _bloc);
        },
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  _moveToEditView(BuildContext context, TodoBloc bloc, Todo todo) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          //todoBloc StreamController
          //todo Todoのデータ
          builder: (context) => TodoEditScreen(todoBloc: bloc, todo: todo),
        ),
      );

  _moveToCreateView(BuildContext context, TodoBloc bloc) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TodoEditScreen(todoBloc: bloc, todo: Todo.newTodo()),
        ),
      );

  _backgroundOfDismissible() => Container(
        alignment: Alignment.centerLeft,
        color: Colors.green,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Icon(Icons.done, color: Colors.white),
        ),
      );

  _secondaryBackgroundOfDismissible() => Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Icon(Icons.done, color: Colors.white),
        ),
      );
}
