import 'package:flutter/material.dart';

/// Activity page
class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: [
        AppBar(
          title: const Text('Activities'),
        ),
        Expanded(
          child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Activities & Reports',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Activity timeline and reports will be displayed here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
          ),
        ),
      ],
    );
}
