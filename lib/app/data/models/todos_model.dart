class TodosModel {
  final String id;
  final String title;
  final bool status;
  final bool starred;
  final DateTime createdAt;

  TodosModel({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.starred,
  });

  factory TodosModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TodosModel(
      id: documentId,
      title: map['title'],
      status: map['status'],
      starred: map['starred'],
      createdAt: map['created_at'].toDate(),
    );
  }
}
