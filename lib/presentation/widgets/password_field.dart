import 'package:food_delivery/core/helper/localized_validation.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/validator.dart';
import 'package:food_delivery/presentation/widgets/custom_text_form_field.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller, this.hint});
  final TextEditingController controller;
  final String? hint;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => CustomTextFormField(
    controller: widget.controller,
    hintText: widget.hint ?? AppLocalizations.of(context)!.password,
    prefixIcon: const Icon(Icons.lock_outline),
    obscureText: hidden,
    validator: (value) =>
        LocalizedValidation.message(context, AuthValidators.password(value)),

    suffixIcon: IconButton(
      icon: Icon(
        hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      onPressed: () => setState(() => hidden = !hidden),
    ),
  );
}
