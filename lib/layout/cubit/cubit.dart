import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/cubit/state.dart';
import 'package:todo_app/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/todo_app/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppState>
{
  AppCubit() : super (AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  int currentIndex = 0;

  List<Widget> screens =
  [
    NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List <String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  void createDatabase()
  {
    openDatabase(
      'todoo.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,time Text, date TEXT, status TEXT)')
            .then((value) {
        }).catchError((error) {
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDataBase({
    required String title,
    required String time,
    required String date
  })async
  {
    await database.transaction((txn) {
      return txn
        .rawInsert(
      'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
    )
        .then((value) {
      emit(AppInsertDatabaseState());

      getDataFromDatabase(database);
    }).catchError((error) {
    });
    });
  }

  void updateData(
  {
  required String status,
  required int id,
  })
  {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ? ',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData(
      {
        required int id,
      })
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ? ',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void getDataFromDatabase(database) async
  {
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value)
    {
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];

      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }


  bool isBottomSheetShown =false;
  IconData fabIcon = Icons.add;

  void changeBottomSheetState(
  {required bool isShow,
  required IconData icon,
  })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}