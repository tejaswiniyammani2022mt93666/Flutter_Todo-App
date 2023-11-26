// ignore_for_file: sort_child_properties_last, dead_code, prefer_const_declarations, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, deprecated_member_use, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '8nZjeKp7ZkqS9IE8YuJDKnOl3JPgxySTALSlxTV5';
  final keyClientKey = 'brx2fd71nsoW1ygr3IoUg4wuLSee0tHM8Auve6IX';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MaterialApp(
    home: Home(),
  ));
}

class TaskDetailsScreen extends StatelessWidget {
  final String title;
  final String description;

  TaskDetailsScreen({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: $title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Description: $description',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoTitleController = TextEditingController();
  final todoDescriptionController = TextEditingController();

  void addToDo() async {
    if (todoTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(
      todoTitleController.text,
      todoDescriptionController.text,
    );
    setState(() {
      todoTitleController.clear();
      todoDescriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parse Todo List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoTitleController,
                  decoration: InputDecoration(
                    labelText: "New todo title",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: todoDescriptionController,
                  decoration: InputDecoration(
                    labelText: "New todo description",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.blueAccent,
                  ),
                  onPressed: addToDo,
                  child: Text("ADD"),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTodo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final varTodo = snapshot.data![index];
                          final varTitle = varTodo.get<String>('title')!;
                          final varDescription =
                              varTodo.get<String>('description') ??
                                  'No description';
                          final varDone = varTodo.get<bool>('done')!;

                          return ListTile(
                            title: Text(varTitle),
                            subtitle: Text(varDescription),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsScreen(
                                    title: varTitle,
                                    description: varDescription,
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              child: Icon(varDone ? Icons.check : Icons.error),
                              backgroundColor:
                                  varDone ? Colors.green : Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: varDone,
                                  onChanged: (value) async {
                                    await updateTodo(varTodo.objectId!, value!);
                                    setState(() {
                                      // Refresh UI
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await deleteTodo(varTodo.objectId!);
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Todo deleted!"),
                                        duration: Duration(seconds: 2),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveTodo(String title, String description) async {
    final todo = ParseObject('Todo')
      ..set('title', title)
      ..set('description', description)
      ..set('done', false);
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Todo'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todo = ParseObject('Todo')
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject('Todo')..objectId = id;
    await todo.delete();
  }
}
