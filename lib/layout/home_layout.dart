// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:to_do/shared/common_widget.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/cubit_states.dart';

// ignore: camel_case_types, must_be_immutable
class homeLayout extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  var tasks = TextEditingController();
  var date = TextEditingController();
  var time = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is InsertDatabase) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Todo App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(cubit.fabIcon),
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formkey.currentState!.validate()) {
                  cubit.insertToDatabase(
                    task_title: tasks.text,
                    task_time: time.text,
                    task_date: date.text,
                  );
                }
              } else {
                scaffoldkey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField2(
                                      controller: tasks,
                                      label: 'Tasks',
                                      prefix: Icons.list_outlined,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'tasks must not be empty';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  defaultFormField2(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      controller: time,
                                      label: 'Time',
                                      prefix: Icons.watch_later_outlined,
                                      ontap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          time.text =
                                              value!.format(context).toString();
                                        });
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  defaultFormField2(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                      controller: date,
                                      label: 'Date',
                                      prefix: Icons.calendar_today_outlined,
                                      ontap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-12-30'),
                                        ).then((value) {
                                          date.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      }),
                                ]),
                          ),
                        ),
                      ),
                      elevation: 20.0,
                    )
                    .closed
                    .then((value) {
                  cubit.isBottomSheetShown = false;
                  cubit.BS_changes();
                });

                cubit.isBottomSheetShown = true;
                cubit.BS_changes();
              }
            },
          ),
          body: cubit.screens[cubit.indexOfButton],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.indexOfButton,
            selectedIconTheme: const IconThemeData(
              size: 40,
            ),
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              cubit.changeScreen(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.done,
                ),
                label: 'done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive,
                ),
                label: 'archive',
              ),
            ],
          ),
        );
      }),
    );
  }
}
