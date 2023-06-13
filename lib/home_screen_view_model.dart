import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewModel {
  List<String> todos = [];
  SharedPreferences? _prefs;

  Future<void> loadTodos() async {
    _prefs = await SharedPreferences.getInstance();
    todos = _prefs!.getStringList('todos') ?? [];
  }

  Future<void> addTodo(String todo) async {
    todos.add(todo);
    await _saveTodos();
  }

  Future<void> removeTodo(int index) async {
    todos.removeAt(index);
    await _saveTodos();
  }

  Future<void> _saveTodos() async {
    await _prefs!.setStringList('todos', todos);
  }
}
