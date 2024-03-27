// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // * Icon
        Icon(
          icon,
          size: 32,
        ),

        const SizedBox(height: 8),

        // * Time
        Text(title),

        const SizedBox(height: 8),

        // * Temperature
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
