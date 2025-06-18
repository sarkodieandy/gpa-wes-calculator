import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/course _model.dart';
import '../models/university_model.dart';
import '../providers/app_state.dart';
import '../services/ad_services.dart';
import '../widgets/animated.dart';
import '../widgets/course_list_tile.dart';
import '../widgets/input dacoration.dart';
import 'pdf_preview_screen.dart';

class WesEvaluationScreen extends StatefulWidget {
  const WesEvaluationScreen({super.key});

  @override
  State<WesEvaluationScreen> createState() => _WesEvaluationScreenState();
}

class _WesEvaluationScreenState extends State<WesEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  String _selectedGrade = 'A';
  double _selectedCreditHours = 3.0;
  double _selectedGpaScale = 4.0;
  bool _snackBarActive = false;

  final List<String> _grades = ['A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'E', 'F'];
  final List<double> _creditOptions = [
    0,
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
  ];
  final List<double> _gpaScales = [4.0, 5.0, 10.0];

  @override
  void dispose() {
    _courseNameController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    if (_snackBarActive) return;
    _snackBarActive = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message, style: GoogleFonts.poppins()),
            backgroundColor: color,
            duration: const Duration(seconds: 3),
          ),
        )
        .closed
        .then((_) => _snackBarActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    const poppins = GoogleFonts.poppins;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(IconlyLight.arrowLeft2),
                      color: theme.colorScheme.primary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'WES GPA Conversion',
                        style: poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.swap),
                      color: theme.colorScheme.primary,
                      onPressed: appState.resetCalculator,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<University>(
                  value: appState.selectedUniversity,
                  decoration: customInputDecoration(
                    context,
                    'Select University',
                    IconlyLight.category,
                  ),
                  items: appState.allUniversities.map((university) {
                    return DropdownMenuItem(
                      value: university,
                      child: Text(university.name, style: poppins()),
                    );
                  }).toList(),
                  onChanged: (university) {
                    if (university != null) {
                      appState.selectUniversity(university);
                    }
                  },
                  validator: (value) =>
                      value == null ? 'Please select a university' : null,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _courseNameController,
                        decoration: customInputDecoration(
                          context,
                          'Course Name',
                          IconlyLight.bookmark,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter a course name'
                            : null,
                        style: poppins(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGrade,
                              decoration: customInputDecoration(
                                context,
                                'Grade',
                                IconlyLight.star,
                              ),
                              items: _grades.map((grade) {
                                return DropdownMenuItem(
                                  value: grade,
                                  child: Text(grade, style: poppins()),
                                );
                              }).toList(),
                              onChanged: (grade) {
                                if (grade != null) {
                                  setState(() => _selectedGrade = grade);
                                }
                              },
                              validator: (value) => value == null
                                  ? 'Please select a grade'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<double>(
                              value: _selectedCreditHours,
                              decoration: customInputDecoration(
                                context,
                                'Credit Hours',
                                IconlyLight.timeCircle,
                              ),
                              items: _creditOptions.map((credit) {
                                return DropdownMenuItem(
                                  value: credit,
                                  child: Text(
                                    credit.toString(),
                                    style: poppins(),
                                  ),
                                );
                              }).toList(),
                              onChanged: (credit) {
                                if (credit != null) {
                                  setState(() => _selectedCreditHours = credit);
                                }
                              },
                              validator: (value) =>
                                  value == null ? 'Select credit hours' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<double>(
                        value: _selectedGpaScale,
                        decoration: customInputDecoration(
                          context,
                          'GPA Scale',
                          IconlyLight.chart,
                        ),
                        items: _gpaScales.map((scale) {
                          return DropdownMenuItem(
                            value: scale,
                            child: Text(scale.toString(), style: poppins()),
                          );
                        }).toList(),
                        onChanged: (scale) {
                          if (scale != null) {
                            setState(() => _selectedGpaScale = scale);
                            appState.setGpaScale(scale);
                          }
                        },
                        validator: (value) =>
                            value == null ? 'Please select a GPA scale' : null,
                      ),
                      const SizedBox(height: 24),
                      AnimatedButton(
                        icon: IconlyLight.plus,
                        text: 'Add Course',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (appState.selectedUniversity == null) {
                              _showSnackBar(
                                context,
                                'Please select a university',
                                theme.colorScheme.error,
                              );
                              return;
                            }
                            appState.addCourse(
                              Course(
                                name: _courseNameController.text,
                                grade: _selectedGrade,
                                creditHours: _selectedCreditHours,
                              ),
                            );
                            _courseNameController.clear();
                            _showSnackBar(
                              context,
                              'Course added',
                              theme.colorScheme.primary,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (appState.courses.isNotEmpty) ...[
                  Text(
                    'Courses',
                    style: poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appState.courses.length,
                    itemBuilder: (context, index) {
                      final course = appState.courses[index];
                      return CourseListCard(course: course, index: index);
                    },
                  ),
                ],
                const SizedBox(height: 24),
                AnimatedButton(
                  icon: IconlyLight.paper,
                  text: 'Calculate WES GPA',
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary,
                      theme.colorScheme.primary,
                    ],
                  ),
                  onPressed: () {
                    if (appState.courses.isEmpty) {
                      _showSnackBar(
                        context,
                        'Please add at least one course',
                        theme.colorScheme.error,
                      );
                      return;
                    }
                    if (appState.selectedUniversity == null) {
                      _showSnackBar(
                        context,
                        'Please select a university',
                        theme.colorScheme.error,
                      );
                      return;
                    }
                    appState.calculateGPA();
                    appState.calculateWesGpa();
                    _showSnackBar(
                      context,
                      'GPA and WES GPA calculated',
                      theme.colorScheme.primary,
                    );
                  },
                ),
                if (appState.cumulativeGpa != null &&
                    appState.wesResult != null) ...[
                  const SizedBox(height: 24),
                  _buildResultCard(
                    context,
                    appState.cumulativeGpa!,
                    appState.wesResult!,
                  ),
                  const SizedBox(height: 24),
                  AnimatedButton(
                    icon: IconlyLight.document,
                    text: 'Export to PDF',
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.secondary,
                        theme.colorScheme.primary,
                      ],
                    ),
                    onPressed: () {
                      AdService.showRewardedAd(
                        onRewarded: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PdfPreviewScreen(),
                            ),
                          );
                        },
                        onAdUnavailable: () {
                          _showSnackBar(
                            context,
                            'Ad not ready, try again shortly',
                            theme.colorScheme.error,
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    double localGpa,
    double wesGpa,
  ) {
    final theme = Theme.of(context);
    const poppins = GoogleFonts.poppins;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primaryContainer.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'GPA Results',
              style: poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Local GPA',
                      style: poppins(
                        fontSize: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      localGpa.toStringAsFixed(2),
                      style: poppins(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Icon(
                  IconlyLight.swap,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
                Column(
                  children: [
                    Text(
                      'WES GPA',
                      style: poppins(
                        fontSize: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      wesGpa.toStringAsFixed(2),
                      style: poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
