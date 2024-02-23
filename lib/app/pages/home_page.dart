import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_motion/app/widget/todo_item_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // TextEditingController untuk mengontrol input teks
  final TextEditingController _textEditingController = TextEditingController();

  // Fungsi akan dipanggil ketika tombol 'tambah todo' ditekan
  void handleCreateTodo() {
    String todoTitle = _textEditingController.text.trim();

    if (todoTitle.isNotEmpty) {
      FirebaseFirestore.instance.collection('todos').add({
        'title': todoTitle,
        'status': false, // status default unchecked
        'create_at': DateTime.now(),
      }).then((_) {
        // Bersihkan bidang teks setelah menambahkan todo
        _textEditingController.clear();
      }).catchError((error) {
        print("Gagal menambahkan todo: $error");
      });
    }
  }

  // Fungsi akan dipanggil ketika menghapus salah satu todo
  void handleDeleteTodo(String id) {
    FirebaseFirestore.instance.collection('todos').doc(id).delete().then((_) {
      print("Todo dengan id: $id berhasil dihapus");
    }).catchError((error) {
      print("Gagal menghapus todo: $error");
    });
  }

  // Fungsi akan dipanggil ketika todo di checklist/unchecklist
  void handleToggleTodo(String id, bool status) {
    FirebaseFirestore.instance.collection('todos').doc(id).update({
      'status': !status, // Toggle status
    }).then((_) {
      print("Todo dengan id: $id berhasil diperbarui");
    }).catchError((error) {
      print("Gagal memperbarui todo: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 255, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 190, 211, 200),
        title: const Text(
          'To do list',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('todos')
                  .orderBy('create_at', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return TodoItemWidget(
                            id: document.id,
                            name: data['title'],
                            status: data['status'],
                            onDelete: (String id) =>
                                handleDeleteTodo(document.id),
                            onToggle: (String id, bool status) =>
                                handleToggleTodo(document.id, status),
                          );
                        },
                      ).toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('Tidak ada data yang tersedia'),
                  );
                }
              },
            ),

            // Menambahkan todos
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          hintText: 'Tambahkan item todo baru',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.pink,
                    ),
                    child: TextButton(
                      onPressed: () {
                        handleCreateTodo();
                      },
                      child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
