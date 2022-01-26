class Task {
  int? id;
  String body;
  bool reminderIsSet;

  Task({
    this.id,
    required this.body,
    required this.reminderIsSet,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        body: json['body'],
        reminderIsSet: json['reminderIsSet'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': body,
      'reminderIsSet': reminderIsSet,
    };
  }
}
