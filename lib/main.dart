import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_theme.dart';
import 'package:food_delivery/core/helper/app_settings.dart';
import 'package:food_delivery/firebase_options.dart';
import 'package:food_delivery/injection.dart';
import 'package:food_delivery/core/routing/app_router.dart';
import 'package:food_delivery/core/routing/routes.dart';
import 'package:food_delivery/core/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSettings.load();
  setupDependencies();
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: ValueListenableBuilder<bool>(
        valueListenable: AppSettings.arabic,
        builder: (context, arabic, _) => ValueListenableBuilder<bool>(
          valueListenable: AppSettings.darkMode,
          builder: (context, darkMode, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'StreetBite',
            locale: Locale(arabic ? 'ar' : 'en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: Routes.root,
            onGenerateRoute: const AppRouter().generateRoute,
          ),
        ),
      ),
    );
  }
}
