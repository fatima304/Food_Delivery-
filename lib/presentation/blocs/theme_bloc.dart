import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helper/app_settings.dart';

sealed class ThemeEvent {
  const ThemeEvent();
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.isDark);
  final bool isDark;
}

/// Theme is persisted using the existing SharedPreferences settings key.
class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc()
    : super(AppSettings.darkMode.value ? ThemeMode.dark : ThemeMode.light) {
    on<ThemeChanged>((event, emit) async {
      emit(event.isDark ? ThemeMode.dark : ThemeMode.light);
      await AppSettings.setDarkMode(event.isDark);
    });
  }
}
