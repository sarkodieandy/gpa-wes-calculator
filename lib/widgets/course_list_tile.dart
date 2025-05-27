import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/course _model.dart';
import '../providers/app_state.dart';

class CourseListCard extends StatelessWidget {
  final Course course;
  final int index;

  const CourseListCard({super.key, required this.course, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.read<AppState>();

    return Card(
      key: ValueKey(course.name),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(IconlyLight.bookmark, color: theme.colorScheme.primary),
        title: Text(
          course.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Grade: ${course.grade} | Credits: ${course.creditHours}',
          style: GoogleFonts.poppins(),
        ),
        trailing: IconButton(
          icon: Icon(IconlyLight.delete, color: theme.colorScheme.error),
          onPressed: () => appState.deleteCourse(index),
        ),
      ),
    );
  }
}
