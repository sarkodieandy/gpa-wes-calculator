import 'package:flutter/material.dart';

import '../models/course _model.dart';
import '../models/university_model.dart';
import '../models/wes_conversional _model.dart';

class AppState with ChangeNotifier {
  bool _isPremium = false;
  University? _selectedUniversity;
  final List<Course> _courses = [];
  double? _cumulativeGpa;
  double? _wesResult;
  double? _inputGpa;
  double _gpaScale = 4.0; // Default scale

  // ✅ Updated: All public universities
  final List<University> allUniversities = University.all;

  // Getters
  bool get isPremium => _isPremium;
  University? get selectedUniversity => _selectedUniversity;
  List<Course> get courses => List.unmodifiable(_courses);
  double? get cumulativeGpa => _cumulativeGpa;
  double? get gpaResult => _cumulativeGpa; // Alias for compatibility
  double? get wesResult => _wesResult;
  double? get inputGpa => _inputGpa;
  double get gpaScale => _gpaScale;

  // Setters and methods
  void setPremium(bool value) {
    _isPremium = value;
    notifyListeners();
  }

  void selectUniversity(University university) {
    _selectedUniversity = university;
    notifyListeners();
  }

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void deleteCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      notifyListeners();
    }
  }

  void setInputGpa(double gpa) {
    _inputGpa = gpa;
    notifyListeners();
  }

  void setGpaScale(double scale) {
    _gpaScale = scale;
    notifyListeners();
  }

  void calculateGPA() {
    if (_selectedUniversity == null || _courses.isEmpty) return;

    double totalQualityPoints = 0;
    double totalCreditHours = 0;

    for (var course in _courses) {
      double gradePoint = _selectedUniversity!.gradePoints[course.grade] ?? 0;
      totalQualityPoints += gradePoint * course.creditHours;
      totalCreditHours += course.creditHours;
    }

    _cumulativeGpa = totalCreditHours > 0
        ? totalQualityPoints / totalCreditHours
        : 0.0;
    notifyListeners();
  }

  void calculateWesGpa() {
    final gpaToConvert = _cumulativeGpa ?? _inputGpa;
    if (gpaToConvert == null) return;

    double scaledGpa = (gpaToConvert / _gpaScale) * 4.0;
    _wesResult = WESConverter.convertToWES(scaledGpa);
    notifyListeners();
  }

  void resetCalculator() {
    _courses.clear();
    _cumulativeGpa = null;
    _wesResult = null;
    _inputGpa = null;
    _gpaScale = 4.0;
    notifyListeners();
  }
}
