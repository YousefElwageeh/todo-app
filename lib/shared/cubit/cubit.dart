import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/Screens/archive_tasks.dart';
import 'package:to_do/Screens/done_tasks.dart';
import 'package:to_do/Screens/tasks_screen.dart';
import 'package:to_do/shared/cubit/cubit_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppCubitInit());

  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;

  List DoneTasks = [];

  List NewTasks = [];

  List ArchivedTasks = [];
  int indexOfButton = 0;
  bool isBottomSheetShown = false;
  var fabIcon = Icons.edit;

  void BS_changes() {
    if (isBottomSheetShown) {
      fabIcon = Icons.add;
    } else {
      fabIcon = Icons.edit;
    }
    emit(ChangeIcon());
  }

  List<Widget> screens = [
    tasksScreen(),
    doneTasks(),
    archiveScreen(),
  ];

  void changeScreen(int index) {
    indexOfButton = index;
    emit(ChangeScreenBN());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');

        getData(database);
      },
    ).then((value) {
      database = value;

      emit(CreatDatabase());
    });
  }

  insertToDatabase({
    required String task_title,
    required String task_time,
    required String task_date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$task_title", "$task_date", "$task_time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(InsertDatabase());
        getData(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  void getData(database) async {
    DoneTasks = [];
    NewTasks = [];
    ArchivedTasks = [];

    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['status'] == 'new') {
          NewTasks.add(e);
        } else if (e['status'] == 'done') {
          DoneTasks.add(e);
        } else {
          ArchivedTasks.add(e);
        }
      });
    });
    emit(GetDatabase());
  }

  void updateDatabase({
    required String status,
    required int id,
  }) {
    database
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id]);
    getData(database);
    emit(UpdateDatabase());
  }

  void delet_database({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    emit(DeletDatabase());
    getData(database);
  }
}
