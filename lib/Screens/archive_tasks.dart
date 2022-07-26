// ignore_for_file: camel_case_types, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/common_widget.dart';
import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/cubit_states.dart';

class archiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var Tasks = AppCubit.get(context).ArchivedTasks;
        return ListView.separated(
            itemBuilder: (context, index) => bulidtask(Tasks[index], context),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey,
                  height: 1,
                  width: double.infinity,
                ),
            itemCount: Tasks.length);
      },
    );
  }
}
