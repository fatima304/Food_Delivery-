import 'package:flutter/material.dart';

import '../widgets/app_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    bottomNavigationBar: const AppNav(index: 4),
  );
}
