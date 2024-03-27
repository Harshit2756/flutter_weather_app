import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  final String iconUrl;
  final String time;
  final String temperature;
  const HourlyForcastItem({
    super.key,
    required this.iconUrl,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: Colors.blueGrey.shade900,
        ),
        child: Column(
          children: [
            // * Time
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // * Icon
            Image.network(
              iconUrl,
              color: Colors.white,
            ),

            const SizedBox(height: 8),

            // * Temperature
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
