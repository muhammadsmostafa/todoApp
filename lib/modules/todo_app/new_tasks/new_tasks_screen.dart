import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/cubit/cubit.dart';
import 'package:todo_app/layout/cubit/state.dart';
import 'package:todo_app/shared/components.dart';


class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(
            tasks: tasks,
        );
      },
    );
  }
}
