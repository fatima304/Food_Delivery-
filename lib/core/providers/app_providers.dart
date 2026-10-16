import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../../presentation/blocs/auth_cubit.dart';
import '../../presentation/blocs/theme_bloc.dart';
import '../../presentation/blocs/cart_bloc.dart';
import '../../presentation/blocs/favourites_cubit.dart';

/// Shared state must live above MaterialApp's Navigator so it is visible
/// from every named route. Route-specific Cubits belong in AppRouter.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => getIt<ThemeBloc>()),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<CartBloc>.value(value: getIt<CartBloc>()),
        BlocProvider<FavouritesCubit>.value(value: getIt<FavouritesCubit>()),
      ],
      child: child,
    );
  }
}
