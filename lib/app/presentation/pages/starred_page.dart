import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolist_motion/app/data/models/todos_model.dart';
import 'package:todolist_motion/app/presentation/controller/home_controller.dart';
import 'package:todolist_motion/app/presentation/widget/todo_item_widget.dart';

class StarredPage extends StatelessWidget {
  const StarredPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = HomeController();

    return Scaffold(
      backgroundColor: Colors.greenAccent.withOpacity(0.3),
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Starred Todos',
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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('todolist')
                      .where(
                        'starred',
                        isEqualTo: true,
                      )
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
                      List<TodosModel> starredTodos = snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return TodosModel.fromMap(
                            data,
                            document.id,
                          );
                        },
                      ).toList();
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: starredTodos.length,
                        itemBuilder: (context, index) {
                          return TodoItemWidget(
                            todo: starredTodos[index],
                            onStarred: () => controller.handleStarredTodo(
                              starredTodos[index].id,
                              starredTodos[index].starred,
                            ),
                            onToggle: () => controller.handleToggleTodo(
                              starredTodos[index].id,
                              starredTodos[index].status,
                            ),
                            onDelete: () => controller.handleDeleteTodo(
                              starredTodos[index].id,
                            ),
                          );
                        },
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
                            'Starred Todos is Empty',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
