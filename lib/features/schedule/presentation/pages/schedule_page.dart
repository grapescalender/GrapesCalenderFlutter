import 'package:flutter/material.dart';

/// Schedule page
class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Schedule & Calendar'),
        ),
        Expanded(
          child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Calendar and Schedule Page',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Detailed schedule management will be displayed here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
          ),
        ),
      ],
    );
  }
}
