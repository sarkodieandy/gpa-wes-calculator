import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
  BuildContext context,
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    filled: true,
    labelStyle: Theme.of(context).textTheme.labelMedium,
    fillColor: Theme.of(context).colorScheme.surfaceContainer,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
  );
}
