import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_motion/app/utils/logging.dart';
import '../../data/models/todos_model.dart';

class HomeController {
  final TextEditingController textEditingController = TextEditingController();
  final List<TodosModel> _starred = [];
  List<TodosModel> get starred => _starred;

  // Fungsi akan dipanggil ketika tombol 'tambah todo' ditekan
  void handleCreateTodo() {
    String todoTitle = textEditingController.text.trim();

    if (todoTitle.isNotEmpty) {
      FirebaseFirestore.instance.collection('todolist').add({
        'title': todoTitle,
        'status': false,
        'starred': false,
        'created_at': DateTime.now(),
      }).then((_) {
        // Bersihkan bidang teks setelah menambahkan todo
        textEditingController.clear();
      }).catchError((error) {
        log.e("Gagal menambahkan todo: $error");
      });
    }
  }

  // Fungsi akan dipanggil ketika menghapus salah satu todo
  void handleDeleteTodo(String id) {
    FirebaseFirestore.instance
        .collection('todolist')
        .doc(id)
        .delete()
        .then((_) {
      log.i("Todo dengan id: $id berhasil dihapus");
    }).catchError((error) {
      log.e("Gagal menghapus todo: $error");
    });
  }

  // Fungsi akan dipanggil ketika todo di checklist/unchecklist
  void handleToggleTodo(String id, bool status) {
    FirebaseFirestore.instance.collection('todolist').doc(id).update({
      'status': !status, // Toggle status
    }).then((_) {
      log.i("Todo dengan id: $id berhasil diperbarui");
    }).catchError((error) {
      log.e("Gagal memperbarui todo: $error");
    });
  }

  void handleEditTodo(String id, String newTitle) {
    FirebaseFirestore.instance
        .collection('todolist')
        .doc(id)
        .update({'title': newTitle}).then((_) {
      log.i("Todo dengan id: $id berhasil diubah");
    }).catchError((error) {
      log.e("Gagal mengubah todo: $error");
    });
  }

  void handleStarredTodo(String id, bool starred) {
    FirebaseFirestore.instance.collection('todolist').doc(id).update({
      'starred': !starred, // Toggle status
    }).then((_) {
      log.i("Stared dengan id: $id berhasil diperbarui");

      if (!starred) {
        FirebaseFirestore.instance
            .collection('todolist')
            .doc(id)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            TodosModel todo = TodosModel.fromMap(data, id);
            _starred.add(todo);
          }
        });
      } else {
        _starred.removeWhere((todo) => todo.id == id);
      }
    }).catchError((error) {
      log.e("Gagal memperbarui Starred: $error");
    });
  }

  bool isExist(String id) {
    return _starred.any((todo) => todo.id == id);
  }
}
