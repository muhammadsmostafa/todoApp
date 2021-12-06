import 'package:flutter/material.dart';
import 'package:todo_app/layout/cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

Widget buildTaskItem(Map model, context) => Dismissible (
  key: Key (model ['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(
            '${model['time']}',
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model['title']}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${model['date']}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),),
        IconButton(
            onPressed:()
            {
              AppCubit.get(context).updateData(
                status:'done',
                id: model['id'],
              );
            },
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
        ),
        IconButton(
          onPressed:()
          {
            AppCubit.get(context).updateData(
              status:'archive',
              id: model['id'],
            );
          },
          icon: const Icon(
            Icons.archive,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id:model['id'],);
  },
);