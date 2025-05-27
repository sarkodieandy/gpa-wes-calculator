import 'course _model.dart';

class Semester {
  final String name;
  final List<Course> courses;
  double? gpa;

  Semester({required this.name, this.courses = const [], this.gpa});
}
