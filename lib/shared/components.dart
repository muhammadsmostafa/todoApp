import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/task_item.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String val)? onSubmit,
  Function(String val)? onChange,
  Function()? onTap,
  Function()? suffixPressed,
  bool isPassword = false,
  required String? Function(String? val)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            :null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

Widget myDivider() => Padding (
  padding: const EdgeInsetsDirectional.only(
    start:20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget tasksBuilder({
  required List<Map> tasks,
}
    ) => BuildCondition(
  condition: tasks.isNotEmpty,
  builder: (context)=> ListView.separated(
      itemBuilder: (context , index)=> buildTaskItem(tasks[index], context),
      separatorBuilder: (context , index)=>myDivider(),
      itemCount: tasks.length),
  fallback: (context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
            'No Tasks Yet, Please Add Some Tasks',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            )
        ),
      ],
    ),
  ) ,
);