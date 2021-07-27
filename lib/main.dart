import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo/adapters/todo_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/theme.dart';
import 'package:todo/model_provider/theme_provider.dart';
import 'package:todo/screens/todo_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: notifier.darkMode ? dark_mode : light_mode,
          home: TodoView(),
        );
      }),
    );
  }
}
