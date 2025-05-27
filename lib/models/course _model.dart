class Course {
  final String name;
  final String grade;
  final double creditHours;

  Course({required this.name, required this.grade, required this.creditHours});

  // Optional: Add a method to convert to Map for serialization
  Map<String, dynamic> toMap() {
    return {'name': name, 'grade': grade, 'creditHours': creditHours};
  }

  // Optional: Add a factory constructor to create from Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'] ?? '',
      grade: map['grade'] ?? '',
      creditHours: map['creditHours']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Course(name: $name, grade: $grade, creditHours: $creditHours)';
  }
}
