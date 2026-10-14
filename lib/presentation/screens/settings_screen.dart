import '../widgets/app_back_button.dart';

import 'package:food_delivery/core/helper/localized_state_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/core/helper/app_settings.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../blocs/device_info_cubit.dart';
import '../blocs/device_info_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.darkMode,
            builder: (_, dark, _) => SwitchListTile(
              title: Text(l10n.darkTheme),
              value: dark,
              onChanged: (value) async {
                await AppSettings.setDarkMode(value);
                // Theme will update automatically via ValueListenableBuilder in main.dart
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.arabic,
            builder: (_, arabic, _) => SwitchListTile(
              title: Text(l10n.languageArabic),
              value: arabic,
              onChanged: (value) async {
                await AppSettings.setArabic(value);
              },
            ),
          ),
          BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
            builder: (context, state) {
              String subtitle;
              if (state.status == DeviceInfoStatus.initial ||
                  state.status == DeviceInfoStatus.loading) {
                subtitle = l10n.loadingDeviceInfo;
              } else if (state.status == DeviceInfoStatus.success &&
                  state.deviceInfo != null) {
                final info = state.deviceInfo!;
                subtitle = '${info.modelName} • OS ${info.osVersion}';
              } else {
                subtitle = state.errorMessage == null
                    ? l10n.deviceDetailsUnavailable
                    : localizedStateError(context, state.errorMessage);
              }
              return ListTile(
                // leading: const Icon(Icons.phone_android_outlined),
                title: Text(l10n.aboutApp),
                subtitle: Text(subtitle),
              );
            },
          ),
        ],
      ),
    );
  }
}
