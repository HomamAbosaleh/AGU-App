class Student {
  final String? name;
  final String? surname;
  final double? gpa;
  final String? id;
  final String? email;
  final String? faculty;
  final String? department;
  final String? status;
  final int? semester;
  final List<Map<String, String>>? courses;
  final double? wallet;

  Student(
      {this.name,
      this.surname,
      this.gpa,
      this.id,
      this.email,
      this.department,
      this.status,
      this.faculty,
      this.semester,
      this.courses,
      this.wallet});
}
