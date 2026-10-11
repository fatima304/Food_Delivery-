import 'package:flutter/material.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_section.dart';
import '../widgets/auth_footer.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Column(
      children: [
        const AuthHeader(
          title: 'Welcome back',
          subtitle: 'Sign in to continue to your account',
        ),
        LoginForm(
          onValidSubmit: (email, password) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login UI validated — connect your auth service'),
              ),
            );
          },
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
  );
}
