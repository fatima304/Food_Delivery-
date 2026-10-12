import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/ui_parts.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tracking Order')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 230,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 65,
                  color: AppColors.primaryGreen,
                ),
                Text('Map preview — Google Maps not connected'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const GreenTag('Arrives in 10–15 min'),
        const SectionHeading('Preparing your order'),
        for (final step in [
          'Order received',
          'Cooking your order',
          'Courier is picking up order',
          'Order delivered',
        ])
          ListTile(
            leading: Icon(
              step == 'Order received'
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: AppColors.primaryGreen,
            ),
            title: Text(step),
          ),
        const UiCard(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Omar H.'),
            subtitle: Text('Your courier'),
          ),
        ),
      ],
    ),
  );
}
