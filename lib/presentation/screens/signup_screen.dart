import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/presentation/blocs/auth_state.dart';

import '../widgets/auth/auth_scaffold.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/signup_form.dart';
import '../widgets/auth/auth_footer.dart';
import '../widgets/auth/auth_feedback.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocListener<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state is AuthError) showAuthFeedback(context, state.message);
      if (state is AuthSuccess) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    },
    child: AuthScaffold(
      child: Column(
        children: [
          AuthHeader(
            title: AppLocalizations.of(context)!.createAccount,
            subtitle: AppLocalizations.of(context)!.signUpSubtitle,
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) => SignupForm(
              isLoading: state is AuthLoading,
              onValidSubmit: (name, email, password) => context
                  .read<AuthCubit>()
                  .signUp(fullName: name, email: email, password: password),
            ),
          ),
          const SizedBox(height: 22),
          AuthFooter(
            message: AppLocalizations.of(context)!.haveAccount,
            action: AppLocalizations.of(context)!.signIn,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
