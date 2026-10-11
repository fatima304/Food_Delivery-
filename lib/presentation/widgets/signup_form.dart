import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/helper/validator.dart';
import 'package:food_delivery/core/style/app_text_styles.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';
import 'package:food_delivery/presentation/widgets/custom_text_form_field.dart';

import 'password_field.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.onValidSubmit,
    this.isLoading = false,
  });
  final void Function(String name, String email, String password) onValidSubmit;
  final bool isLoading;
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final key = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final password = TextEditingController(), confirm = TextEditingController();
  bool agreed = false;
  @override
  void dispose() {
    for (final c in [name, email, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: key,
    child: Column(
      children: [
        CustomTextFormField(
          controller: name,
          hintText: 'Full name',
          prefixIcon: const Icon(Icons.person_outline),
          validator: (value) => AuthValidators.fullName(value),
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          controller: email,
          hintText: 'Email address',
          prefixIcon: const Icon(Icons.mail_outline),
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidators.email,
        ),
        const SizedBox(height: 12),

        const SizedBox(height: 12),
        PasswordField(controller: password),
        const SizedBox(height: 12),
        CustomTextFormField(
          controller: confirm,
          hintText: 'Confirm password',
          prefixIcon: const Icon(Icons.lock_outline),
          obscureText: true,
          validator: (value) =>
              AuthValidators.confirmPassword(value, password.text),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: agreed,
          onChanged: (v) => setState(() => agreed = v ?? false),
          activeColor: AppColors.primaryGreen,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'I agree to the Terms of Service and Privacy Policy',
            style: AppTextStyles.body14DarkRegular,
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: widget.isLoading ? 'Creating account...' : 'Create account',
          onPressed: widget.isLoading
              ? null
              : () {
                  if (!key.currentState!.validate()) return;
                  if (!agreed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please accept the terms first'),
                      ),
                    );
                    return;
                  }
                  widget.onValidSubmit(
                    name.text.trim(),
                    email.text.trim(),
                    password.text,
                  );
                },
        ),
      ],
    ),
  );
}
