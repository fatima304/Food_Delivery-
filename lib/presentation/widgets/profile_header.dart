import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../core/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.localPhoto,
    this.onPhotoTap,
    this.onNameTap,
    this.uploading = false,
  });
  final String name;
  final String email;
  final File? localPhoto;
  final VoidCallback? onPhotoTap;
  final VoidCallback? onNameTap;
  final bool uploading;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
    decoration: const BoxDecoration(
      color: AppColors.primaryGreen,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
    ),
    child: Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightGreen,
                backgroundImage: localPhoto != null
                    ? FileImage(localPhoto!)
                    : null,
                child: localPhoto == null
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primaryGreen,
                        size: 32,
                      )
                    : null,
              ),
            ),
            Positioned(
              right: -5,
              bottom: -4,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: uploading ? null : onPhotoTap,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: uploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: AppColors.primaryGreen,
                            size: 17,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onNameTap,
                    tooltip: AppLocalizations.of(context)!.editNameTooltip,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                ],
              ),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
