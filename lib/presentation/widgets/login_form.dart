import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/validator.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';
import 'package:food_delivery/presentation/widgets/custom_text_form_field.dart';

import 'password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onValidSubmit,
    this.isLoading = false,
  });
  final void Function(String email, String password) onValidSubmit;
  final bool isLoading;
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final key = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: key,
    child: Column(
      children: [
        CustomTextFormField(
          controller: email,
          hintText: 'Email address',
          prefixIcon: const Icon(Icons.mail_outline),
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.email,
        ),
        const SizedBox(height: 14),
        PasswordField(controller: password),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset is not connected yet'),
              ),
            ),
            child: const Text(
              'Forgot password?',
              style: AppTextStyles.link14GreenMedium,
            ),
          ),
        ),
        const SizedBox(height: 34),
        CustomButton(
          text: widget.isLoading ? 'Signing in...' : 'Sign In',
          onPressed: widget.isLoading
              ? null
              : () {
                  if (key.currentState!.validate())
                    widget.onValidSubmit(email.text.trim(), password.text);
                },
        ),
      ],
    ),
  );
}
