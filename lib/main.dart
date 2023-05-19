import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/const_values.dart';
import 'package:todo/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? _prefs;
  bool isDark = true;
  Future<void> _saveUserSettings(bool isDark) async {
    await _prefs!.setBool('isDark', isDark);
  }

  Future<void> loadisDark() async {
    _prefs = await SharedPreferences.getInstance();
    bool? dark = _prefs!.getBool('isDark') ?? true;
    if (dark == null)
      isDark = true;
    else
      isDark = dark;
    setState(() {});
  }

  @override
  void initState() {
    loadisDark();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData.dark(),
        title: ConstValues.appBarTitle,
        home: SafeArea(
          child: Scaffold(
            appBar: buildAppBar(),
            drawer: buildDrawer(),
            body: HomeScreen(),
          ),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.black,
      title: Text(ConstValues.appBarTitle),
      centerTitle: true,
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: ConstValues.primaryColor,
          ),
          child: Center(
            child: Text(
              ConstValues.settings,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(ConstValues.settingNormal),
          onTap: () async {
            isDark = false;
            await _saveUserSettings(false);
            setState(() {});
          },
        ),
        ListTile(
          title: Text(ConstValues.settingsDark),
          onTap: () async {
            isDark = true;
            await _saveUserSettings(true);
            setState(() {});
          },
        ),
      ]),
    );
  }
}
