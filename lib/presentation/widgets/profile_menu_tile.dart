import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.subtitle,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? subtitle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          minLeadingWidth: 20,
          leading: Icon(icon, size: 21, color: scheme.onSurface),
          title: Text(title,
              style: TextStyle(fontSize: 14, color: scheme.onSurface)),
          subtitle: subtitle == null ? null : Text(subtitle!, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          trailing: onTap == null ? null : Icon(Icons.chevron_right,
              size: 20, color: scheme.onSurfaceVariant),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(height: 1, thickness: .6, indent: 20, endIndent: 20),
      ],
    );
  }
}
