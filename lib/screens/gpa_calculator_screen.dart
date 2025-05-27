import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../models/course _model.dart';
import '../models/university_model.dart';
import '../providers/app_state.dart' as my_app_state;
import '../services/ad_services.dart';
import '../widgets/animated.dart';
import '../widgets/course_list_tile.dart';
import '../widgets/input dacoration.dart';

class GpaCalculatorScreen extends StatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  State<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  String _selectedGrade = 'A';
  double _selectedCreditHours = 3.0;
  bool _snackBarActive = false;

  final List<String> _grades = ['A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'E', 'F'];
  final List<double> _creditOptions = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0];

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = AdService.createBannerAd(
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _bannerAd.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, Color bgColor) {
    if (_snackBarActive) return;
    _snackBarActive = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(message, style: GoogleFonts.poppins()),
            backgroundColor: bgColor,
            duration: const Duration(seconds: 3),
          ),
        )
        .closed
        .then((_) => _snackBarActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<my_app_state.AppState>();
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
                        'GPA Calculator',
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
                            ? 'Please enter a course name'
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
                              validator: (value) => value == null
                                  ? 'Please select credit hours'
                                  : null,
                            ),
                          ),
                        ],
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
                    'Added Courses',
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
                      return CourseListCard(
                        course: appState.courses[index],
                        index: index,
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),

                AnimatedButton(
                  icon: IconlyLight.paper,
                  text: 'Calculate GPA',
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
                    _showSnackBar(
                      context,
                      'GPA calculated',
                      theme.colorScheme.primary,
                    );
                  },
                ),

                if (appState.gpaResult != null) ...[
                  const SizedBox(height: 24),
                  _buildGpaCard(
                    context,
                    appState.gpaResult!,
                    appState.selectedUniversity!.name,
                  ),
                ],

                const SizedBox(height: 24),
                if (_isBannerAdLoaded)
                  SizedBox(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGpaCard(BuildContext context, double gpa, String uniName) {
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
              'Your GPA',
              style: poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              gpa.toStringAsFixed(2),
              style: poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Based on $uniName grading system',
              style: poppins(
                fontSize: 14,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
