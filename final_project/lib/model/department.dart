import 'course.dart';

class Department {
  final String name;
  final List<Course>? courses;

  Department({required this.name, this.courses});
}
