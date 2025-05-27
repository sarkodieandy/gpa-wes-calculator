import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../providers/app_state.dart';
import '../models/course _model.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: appState.isPremium ? () => _generatePdf(context) : null,
            tooltip: appState.isPremium ? 'Download PDF' : 'Premium required',
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [_buildReportCard(context, appState)]),
          ),
          if (!appState.isPremium) _buildPremiumOverlay(context),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, AppState appState) {
    final TextStyle titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold);
    final TextStyle labelStyle = Theme.of(context).textTheme.bodyLarge!;
    final TextStyle valueStyle = Theme.of(
      context,
    ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('GPA Report', style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            _buildInfoRow(
              'University:',
              appState.selectedUniversity?.name ?? 'N/A',
              labelStyle,
              valueStyle,
            ),
            const Divider(),
            _buildInfoRow(
              'Local GPA:',
              appState.gpaResult?.toStringAsFixed(2) ?? 'N/A',
              labelStyle,
              valueStyle,
            ),
            const Divider(),
            _buildInfoRow(
              'WES GPA:',
              appState.wesResult?.toStringAsFixed(2) ?? 'N/A',
              labelStyle,
              valueStyle,
            ),
            const SizedBox(height: 24),
            Text('Course Details', style: titleStyle.copyWith(fontSize: 18)),
            const SizedBox(height: 8),
            ...appState.courses.map(
              (course) => _buildCourseRow(course, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }

  Widget _buildCourseRow(Course course, BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(course.name, style: style)),
          Text('${course.grade} (${course.creditHours} credits)', style: style),
        ],
      ),
    );
  }

  Widget _buildPremiumOverlay(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upgrade to export your GPA report',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/premium'),
                child: const Text('Upgrade Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, text: 'GPA Report'),
              pw.SizedBox(height: 16),
              pw.Text(
                'University: ${appState.selectedUniversity?.name ?? 'N/A'}',
              ),
              pw.Divider(),
              pw.Text(
                'Local GPA: ${appState.gpaResult?.toStringAsFixed(2) ?? 'N/A'}',
              ),
              pw.Divider(),
              pw.Text(
                'WES GPA: ${appState.wesResult?.toStringAsFixed(2) ?? 'N/A'}',
              ),
              pw.SizedBox(height: 24),
              pw.Header(level: 1, text: 'Course Details'),
              pw.SizedBox(height: 8),
              ...appState.courses.map((course) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Text(
                    '${course.name}: ${course.grade} (${course.creditHours} credits)',
                  ),
                );
              }),
            ],
          );
        },
      ),
    );

    try {
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'gpa-report-${DateTime.now().toIso8601String()}.pdf',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
    }
  }
}
