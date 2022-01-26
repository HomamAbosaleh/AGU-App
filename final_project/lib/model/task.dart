class Task {
  int? id;
  String body;
  bool reminderIsSet;
  String? reminderDate;

  Task({
    this.id,
    required this.body,
    required this.reminderIsSet,
    this.reminderDate,
  });
}
