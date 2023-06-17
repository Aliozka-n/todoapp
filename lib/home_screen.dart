import 'package:flutter/material.dart';
import 'package:todo/const_values.dart';

import 'home_screen_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenViewModel viewModel = HomeScreenViewModel();
  @override
  void initState() {
    super.initState();
    viewModel.loadTodos().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (viewModel.todos.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: viewModel.todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ConstValues.primaryColor,
                    child: ListTile(
                      title: Text(
                        viewModel.todos[index],
                        style: TextStyle(color: ConstValues.whiteColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: ConstValues.redColor,
                        ),
                        onPressed: () async {
                          removeShowDialog(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (viewModel.todos.isEmpty)
          Expanded(child: Center(child: Text(ConstValues.noTodo))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstValues.primaryColor),
            onPressed: () {
              addShowDialog(context);
            },
            child: Text(ConstValues.addButton),
          ),
        ),
      ],
    );
  }

  Future<dynamic> addShowDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ConstValues.addTodo,
                        prefixIcon: Icon(Icons.ac_unit,
                            color: ConstValues.primaryColor),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstValues.primaryColor,
                        ),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            viewModel.addTodo(controller.text);
                          }
                          controller.clear();
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          ConstValues.addButton,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> removeShowDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      child: ListTile(
                          title: Text(
                              "${viewModel.todos[index]} ${ConstValues.deleteText}")),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstValues.primaryColor,
                          ),
                          onPressed: () {
                            viewModel.removeTodo(index);
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            ConstValues.delete,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
