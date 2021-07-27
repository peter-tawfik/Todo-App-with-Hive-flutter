import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/adapters/todo_adapter.dart';
import 'package:todo/model_provider/theme_provider.dart';
import 'package:todo/screens/add_todo.dart';
import '../theme.dart';

class TodoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Todo App'),
            ),
            ListTile(
              title: const Text('Theme'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ThemePage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Your ToDo List"),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Todo>('todos').listenable(),
          builder: (context, Box<Todo> box, _) {
            if (box.values.isEmpty) {
              return Center(
                child: Text("No data available!",
                    style: TextStyle(fontFamily: 'Montserrat')),
              );
            }
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Todo? todo = box.getAt(index);
                  return Card(
                    child: Dismissible(
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Confirmation"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Delete")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(
                        color: Colors.teal,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              Text('Move to trash',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      key: ValueKey('${todo?.title}' + '${todo?.description}'),
                      onDismissed: (direction) {
                        box.deleteAt(index);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Item Deleted"),
                        ));
                      },
                      child: ListTile(
                        onLongPress: () async {
                          await box.deleteAt(index);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Item Deleted"),
                          ));
                        },
                        title: Text(
                          todo!.title,
                          style:
                              TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.description,
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Montserrat'),
                            ),
                            Text(DateFormat.yMEd().format(todo.time)),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
