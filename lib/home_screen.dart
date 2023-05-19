import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/const_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ChangeNotifier {
  @override
  void initState() {
    loadTodos();
    super.initState();
  }

  List<String> todos = [];
  SharedPreferences? _prefs;

  Future<void> loadTodos() async {
    _prefs = await SharedPreferences.getInstance();
    todos = _prefs!.getStringList('todos') ?? [];
    setState(() {});
    notifyListeners();
  }

  Future<void> addTodo(String todo) async {
    todos.add(todo);
    await _saveTodos();
    setState(() {});

    notifyListeners();
  }

  Future<void> removeTodo(int index) async {
    todos.removeAt(index);
    await _saveTodos();
    setState(() {});

    notifyListeners();
  }

  Future<void> _saveTodos() async {
    await _prefs!.setStringList('todos', todos);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    void _addTodo() async {
      final todo = controller.text;
      if (todo.isNotEmpty) {
        await addTodo(todo);
        setState(() {
          controller.clear();
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (todos.isNotEmpty)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ConstValues.primaryColor,
                    child: ListTile(
                      title: Text(
                        todos[index],
                        style: TextStyle(color: ConstValues.whiteColor),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: ConstValues.redColor,
                        ),
                        onPressed: () async {
                          buildDeleteShowDialog(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (todos.isEmpty)
          Expanded(child: Center(child: Text(ConstValues.noTodo))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ConstValues.primaryColor),
            onPressed: () {
              buildAddShowDialog(context);
            },
            child: Text(ConstValues.addButton),
          ),
        ),
      ],
    );
  }

  Future<dynamic> buildAddShowDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
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
                        focusedBorder: UnderlineInputBorder(
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
                          if (controller.text.isNotEmpty)
                            addTodo(controller.text);
                          controller.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          ConstValues.addButton,
                          style: TextStyle(color: Colors.white),
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

  Future<dynamic> buildDeleteShowDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
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
                              "${todos[index]} ${ConstValues.deleteText}")),
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstValues.primaryColor,
                          ),
                          onPressed: () {
                            removeTodo(index);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            ConstValues.delete,
                            style: TextStyle(color: Colors.white),
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
