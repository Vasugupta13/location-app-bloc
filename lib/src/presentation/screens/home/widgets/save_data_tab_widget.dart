import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/data/repository/save_user_data_repo.dart';
import 'package:parkin_assessment/src/presentation/screens/home/bloc/save_data_bloc.dart';
import 'package:parkin_assessment/src/utils/snackbars_and_toasts.dart';
import 'package:parkin_assessment/src/utils/time_formatter.dart';

class SaveDataTabWidget extends StatefulWidget {
  const SaveDataTabWidget({super.key});

  @override
  State<SaveDataTabWidget> createState() => _SaveDataTabWidgetState();
}

class _SaveDataTabWidgetState extends State<SaveDataTabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<SaveDataBloc>().add(FetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<SaveDataBloc, SaveDataState>(
          builder: (context, state) {
            if (state is SaveDataLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SaveDataSuccess) {
              if (state.userDataList.isEmpty) {
                return Center(child: Text('No Saved Data'));
              }
              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.userDataList.length,
                      itemBuilder: (context, index) {
                        final userData = state.userDataList[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 12),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              outlinedButtonTheme:
                                  const OutlinedButtonThemeData(
                                style: ButtonStyle(
                                  iconColor:
                                      WidgetStatePropertyAll(Colors.white),
                                  iconSize: WidgetStatePropertyAll(30),
                                ),
                              ),
                            ),
                            child: Slidable(
                                key: ValueKey(userData),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        context.read<SaveDataBloc>().add(DeleteUserData(userData));
                                      },
                                      backgroundColor: Colors.red,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12)),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: COLOR_CONST.secondaryColor,
                                          blurRadius: 3,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${userData.name.split(' ').first}, ${userData.age}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(
                                              FormatTime.formatTime(userData.time),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: COLOR_CONST.primaryLightColor.withOpacity(0.5),
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text(userData.note))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is SaveDataFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return Container();
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () => _showAddDataDialog(context),
            child: Icon(
              Icons.add,
              color: COLOR_CONST.primaryColor,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddDataDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add Data',
            style: TextStyle(
                color: COLOR_CONST.primaryLightColor,
                fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Note'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      COLOR_CONST.primaryLightColor),
                  shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
              onPressed: () {
                final name = nameController.text.trim();
                final age = int.tryParse(ageController.text.trim()) ?? 1;
                final note = noteController.text.trim();
                if (nameController.text.isEmpty ||
                    ageController.text.isEmpty ||
                    noteController.text.isEmpty) {
                  SnackbarsAndToasts.showErrorToast("Please fill all fields");
                  return;
                } else if (age > 110 || age < 1) {
                  SnackbarsAndToasts.showErrorToast("Please enter a valid age");
                  return;
                }
                context.read<SaveDataBloc>().add(SaveUserData(name, age, note));
                context.read<SaveDataBloc>().add(FetchUserData());
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
