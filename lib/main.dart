import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/style/app_theme.dart';
import 'package:food_delivery/core/helper/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/firebase_options.dart';
import 'package:food_delivery/injection.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/presentation/blocs/cart_bloc.dart';
import 'package:food_delivery/presentation/blocs/favourites_cubit.dart';
import 'package:food_delivery/presentation/screens/auth_gate.dart';

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
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AuthCubit>(),
    child: BlocProvider(
      create: (_) => getIt<CartBloc>(),
      child: BlocProvider.value(
        value: getIt<FavouritesCubit>(),
        child: ValueListenableBuilder<bool>(
          valueListenable: AppSettings.arabic,
          builder: (_, arabic, _) => ValueListenableBuilder<bool>(
            valueListenable: AppSettings.darkMode,
            builder: (_, darkMode, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'StreetBite',
              locale:  Locale('ar'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              home: const AuthGate(),
            ),
          ),
        ),
      ),
    ),
  );
}
