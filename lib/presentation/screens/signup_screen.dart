import 'package:flutter/material.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/auth_header.dart';
import '../widgets/signup_form.dart';
import '../widgets/auth_footer.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Column(
      children: [
        const AuthHeader(
          title: 'Create account',
          subtitle: 'Join us and start ordering your favorite food',
        ),
        SignupForm(
          onValidSubmit: (name, email, phone, password) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Signup UI validated — connect your auth service',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 22),
        AuthFooter(
          message: 'Already have an account?',
          action: 'Sign In',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ],
    ),
  );
}
