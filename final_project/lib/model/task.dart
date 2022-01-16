class Task {
  final int? id;
  final String body;

  Task({
    this.id,
    required this.body,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        body: json['body'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': body,
    };
  }
}
