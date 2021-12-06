import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';


class HomeLayout extends StatefulWidget
{
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController=TextEditingController();

  var timeController=TextEditingController();

  var dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer <AppCubit , AppState>(
        listener: (context,state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context,state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key : scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body: BuildCondition(
              condition : state is! AppGetDatabaseLoadingState,
              builder: (context)=> cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center (child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if (cubit.isBottomSheetShown)
                {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                }else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                          (context) => Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String? value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Text Title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: ()
                                  {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value)
                                    {
                                      timeController.text = value!.format(context).toString();
                                    });
                                  },
                                  validate: (String? value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  isClickable: true,
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: ()
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2021-12-30'),
                                    ).then((value)
                                    {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    }
                                    );
                                  },
                                  validate: (String? value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  isClickable: true,
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      elevation: 15.0
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(
                      isShow: false,
                      icon: Icons.add,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShow: true,
                    icon: Icons.done,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}