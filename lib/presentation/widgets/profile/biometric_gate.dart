import 'package:flutter/material.dart';
import 'package:food_delivery/core/helper/localized_state_error.dart';
import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:food_delivery/presentation/blocs/biometric_state.dart';

class BiometricGate extends StatelessWidget {
  const BiometricGate({
    super.key,
    required this.state,
    required this.onAuthenticate,
    required this.onLeave,
  });

  final BiometricState state;
  final VoidCallback onAuthenticate;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final busy =
        state.status == BiometricStatus.loading ||
        state.status == BiometricStatus.initial;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fingerprint, size: 64),
            const SizedBox(height: 16),
            Text(
              busy ? l10n.verifyingIdentity : l10n.unlockProfile,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (!busy) ...[
              const SizedBox(height: 10),
              Text(
                state.errorMessage == null
                    ? l10n.biometricRequired
                    : localizedStateError(context, state.errorMessage),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onAuthenticate,
                icon: const Icon(Icons.fingerprint),
                label: Text(l10n.tryAgain),
              ),
              TextButton(onPressed: onLeave, child: Text(l10n.backToHome)),
            ] else ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
