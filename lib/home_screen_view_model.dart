import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewModel extends ChangeNotifier {
  List<String> todos = [];
  SharedPreferences? _prefs;

  Future<void> loadTodos() async {
    _prefs = await SharedPreferences.getInstance();
    todos = _prefs!.getStringList('todos') ?? [];
  }

  Future<void> addTodo(String todo) async {
    todos.add(todo);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> removeTodo(int index) async {
    todos.removeAt(index);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    await _prefs!.setStringList('todos', todos);
  }
}
