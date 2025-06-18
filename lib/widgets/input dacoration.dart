import 'package:flutter/material.dart';

InputDecoration customInputDecoration(
  BuildContext context,
  String label,
  IconData icon,
) {
  final theme = Theme.of(context);
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: theme
        .colorScheme
        .surfaceContainerHighest, // surfaceContainer renamed to surfaceVariant in newer Material3
    labelStyle: theme.textTheme.labelMedium,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(icon, color: theme.colorScheme.primary),
    prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    // Optional:
    // hintText: 'Enter $label',
  );
}
