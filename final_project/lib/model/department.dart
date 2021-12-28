import 'course.dart';

class Department {
  String name = "";
  List<Course>? courses;

  Department({required this.name, required this.courses});
  Department.withA(this.name);
}
