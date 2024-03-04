import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_motion/app/data/models/todos_model.dart';
import 'package:todolist_motion/app/presentation/widget/todo_item_widget.dart';
import 'package:todolist_motion/app/presentation/controller/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = HomeController();

    return Scaffold(
      backgroundColor: Colors.greenAccent.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Todo list',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('todolist')
                    .orderBy(
                      'created_at',
                      descending: true,
                    ) // Order by New Add Todos
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<TodosModel> todos =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return TodosModel.fromMap(
                        data,
                        document.id,
                      );
                    }).toList();
                    return Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        children: todos.map(
                          (TodosModel todo) {
                            return TodoItemWidget(
                              todo: todo,
                              onStarred: () => controller.handleStarredTodo(
                                todo.id,
                                todo.starred,
                              ),
                              onToggle: () => controller.handleToggleTodo(
                                todo.id,
                                todo.status,
                              ),
                              onDelete: () => controller.handleDeleteTodo(
                                todo.id,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Image.asset(
                          'assets/images/empty.png',
                          fit: BoxFit.cover,
                          width: 220,
                        ),
                        const Text(
                          'Todos is Empty',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
