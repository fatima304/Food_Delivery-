import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/widgets/custom_button.dart';
import 'package:food_delivery/presentation/widgets/custom_text_form_field.dart';

import '../widgets/ui_parts.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});
  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final number = TextEditingController(),
      holder = TextEditingController(),
      expiry = TextEditingController(),
      cvv = TextEditingController();
  @override
  void dispose() {
    for (final c in [number, holder, expiry, cvv]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Card')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        CustomTextFormField(
          controller: number,
          hintText: 'Card number',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        CustomTextFormField(controller: holder, hintText: 'Card holder name'),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(controller: expiry, hintText: 'MM/YY'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                controller: cvv,
                hintText: 'CVV',
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text('UI demo only. Do not enter real payment card information.'),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Add Card',
          onPressed: () => showDemo(context, 'Card entry is not connected'),
        ),
      ],
    ),
  );
}
