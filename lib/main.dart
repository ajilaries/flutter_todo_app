import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      // this line sets the overall look and feel of the Flutter app.
      // ThemeData holds all visual styling information for the app.
      // primarySwatch contains multiple color shades.
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = []; // now a list of maps
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Load saved tasks
  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('tasks'); // fixed name
    if (savedData != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  // Save tasks
  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(tasks)); // fixed from getString to setString
  }

  // Add new task
  void addTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add({'title': controller.text, 'completed': false}); // fixed key name
        controller.clear();
      });
      saveTasks();
    }
  }

  // Toggle completion
  void toggleTask(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
    saveTasks();
  }

  // Delete task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Add a new task',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Add one!'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: CheckboxListTile(
                            title: Text(
                              tasks[index]['title'],
                              style: TextStyle(
                                decoration: tasks[index]['completed']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: tasks[index]['completed']
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            value: tasks[index]['completed'],
                            onChanged: (_) => toggleTask(index),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
