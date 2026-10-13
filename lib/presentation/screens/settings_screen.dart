import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/core/helper/app_settings.dart';

import '../../injection.dart';
import '../blocs/device_info_cubit.dart';
import '../blocs/device_info_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<DeviceInfoCubit>()..getDeviceInfo(),
    child: Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.darkMode,
            builder: (_, dark, _) => SwitchListTile(
              title: const Text('Dark Theme'),
              value: dark,
              onChanged: (value) => AppSettings.darkMode.value = value,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.arabic,
            builder: (_, arabic, _) => SwitchListTile(
              title: const Text('Language: Arabic'),
              value: arabic,
              onChanged: (value) => AppSettings.arabic.value = value,
            ),
          ),
          BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
            builder: (context, state) {
              String subtitle;
              if (state.status == DeviceInfoStatus.initial ||
                  state.status == DeviceInfoStatus.loading) {
                subtitle = 'Loading device information...';
              } else if (state.status == DeviceInfoStatus.success &&
                  state.deviceInfo != null) {
                final info = state.deviceInfo!;
                subtitle = '${info.modelName} • OS ${info.osVersion}';
              } else {
                subtitle = state.errorMessage ?? 'Device details unavailable';
              }
              return ListTile(
                // leading: const Icon(Icons.phone_android_outlined),
                title: Text('About App'),
                subtitle: Text(subtitle),
              );
            },
          ),
        ],
      ),
    ),
  );
}
