import 'package:flutter/material.dart';

void main(){
  runApp(const ToDoApp());

} 
class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> tasks = [];
  final TextEditingController controller = TextEditingController();

  void addTask() {
    if (controller.text.isNotEmpty) {
      setState(() {
        tasks.add(controller.text);
        controller.clear();
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'add a new task',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context,index){
              return Card(child:ListTile(
                title: Text(tasks[index]),
                trailing: IconButton(
                  icon:const Icon(Icons.delete,color: Colors.red,),
                  onPressed: ()=>deleteTask(index)),
              ),);

          },))
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: addTask,child: const Icon(Icons.add),),
    );
  }
}
