import 'package:flutter/material.dart';
import '../../data/models/todos_model.dart';
import '../controller/home_controller.dart';

class TodoItemWidget extends StatelessWidget {
  final TodosModel todo;
  final VoidCallback onStarred;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onStarred,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var controller = HomeController();
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        width: MediaQuery.of(context).size.width / 4,
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {},
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          bool dismiss = false;
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Are you sure you want to delete the Todos?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      dismiss = false;
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      onDelete();
                      dismiss = true;
                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
          return dismiss;
        }
        return null;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Card(
          child: ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController textEditingController =
                      TextEditingController(text: todo.title);

                  return AlertDialog(
                    title: const Text('Edit Todos'),
                    content: TextField(
                      controller: textEditingController,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          String newValue = textEditingController.text;
                          controller.handleEditTodo(
                            todo.id,
                            newValue,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: IconButton(
              alignment: Alignment.center,
              icon: Icon(
                todo.status ? Icons.check_circle : Icons.circle_outlined,
                color: Colors.green,
              ),
              onPressed: () {
                onToggle();
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF3A3A3A),
                decoration: todo.status ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 35,
              width: 35,
              decoration: const BoxDecoration(),
              child: IconButton(
                alignment: Alignment.center,
                color: todo.starred ? Colors.red : Colors.grey,
                iconSize: 24,
                icon: const Icon(Icons.star),
                onPressed: onStarred,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
