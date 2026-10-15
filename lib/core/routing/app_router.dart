import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/meal_model.dart';
import '../../injection.dart';
import '../../presentation/blocs/biometric_cubit.dart';
import '../../presentation/blocs/device_info_cubit.dart';
import '../../presentation/blocs/home_cubit.dart';
import '../../presentation/blocs/meal_details_cubit.dart';
import '../../presentation/blocs/search_cubit.dart';
import '../../presentation/screens/auth_gate.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/checkout_screen.dart';
import '../../presentation/screens/favourites_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/meal_details_screen.dart';
import '../../presentation/screens/nearby_vendors_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/orders_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/search_screen.dart';
import '../../presentation/screens/settings_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import 'routes.dart';

/// Arguments are validated centrally so feature screens remain navigation-agnostic.
class MealDetailsArgs {
  const MealDetailsArgs({required this.mealId, this.initialMeal});
  final String mealId;
  final MealModel? initialMeal;
}

class AppRouter {
  const AppRouter();

  Route<dynamic> generateRoute(RouteSettings settings) {
    late final Widget page;
    switch (settings.name) {
      case Routes.root:
        // The auth gate chooses onboarding or home without creating a second
        // navigation stack. HomeCubit belongs to the route, not HomeScreen.
        page = BlocProvider(
          create: (_) => getIt<HomeCubit>()..load(),
          child: const AuthGate(),
        );
        break;
      case Routes.splash:
        page = const SplashScreen();
        break;
      case Routes.onboarding:
        page = const OnboardingScreen();
        break;
      case Routes.login:
        page = const LoginScreen();
        break;
      case Routes.signup:
        page = const SignupScreen();
        break;
      case Routes.home:
        page = BlocProvider(
          create: (_) => getIt<HomeCubit>()..load(),
          child: const HomeScreen(),
        );
        break;
      case Routes.search:
        page = BlocProvider(
          create: (_) => getIt<SearchCubit>()..load(),
          child: const SearchScreen(),
        );
        break;
      case Routes.cart:
        page = const CartScreen();
        break;
      case Routes.checkout:
        page = const CheckoutScreen();
        break;
      case Routes.orders:
        page = const OrdersScreen();
        break;
      case Routes.favourites:
        page = const FavouritesScreen();
        break;
      case Routes.profile:
        page = BlocProvider(
          create: (_) => getIt<BiometricCubit>()..authenticate(),
          child: const ProfileScreen(),
        );
        break;
      case Routes.settings:
        page = BlocProvider(
          create: (_) => getIt<DeviceInfoCubit>()..getDeviceInfo(),
          child: const SettingsScreen(),
        );
        break;
      case Routes.mealDetails:
        final args = settings.arguments;
        if (args is! MealDetailsArgs || args.mealId.isEmpty) {
          return _invalidRoute(settings);
        }
        page = BlocProvider(
          create: (_) => getIt<MealDetailsCubit>()..load(args.mealId),
          child: MealDetailsScreen(
            mealId: args.mealId,
            initialMeal: args.initialMeal,
          ),
        );
        break;
      case Routes.nearbyVendors:
        page = const NearbyVendorsScreen();
        break;
      default:
        return _invalidRoute(settings);
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }

  Route<dynamic> _invalidRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(AppLocalizations.of(context)!.pageNotFound)),
        ),
      );
}
