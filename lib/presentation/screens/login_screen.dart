import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/presentation/blocs/auth_cubit.dart';
import 'package:food_delivery/presentation/blocs/auth_state.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_section.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_feedback.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
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
          const AuthHeader(
            title: 'Welcome back',
            subtitle: 'Sign in to continue to your account',
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) => LoginForm(
              isLoading: state is AuthLoading,
              onValidSubmit: (email, password) => context
                  .read<AuthCubit>()
                  .login(email: email, password: password),
            ),
          ),
          const SizedBox(height: 38),
          const SocialLoginSection(),
          const SizedBox(height: 45),
          AuthFooter(
            message: 'Don’t have an account?',
            action: 'Sign Up',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignupScreen()),
            ),
          ),
        ],
      ),
    ),
  );
}
