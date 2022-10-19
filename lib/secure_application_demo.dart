import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';

class SecureApplicationDemo extends StatelessWidget {
  const SecureApplicationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the application and mark it as a secure one.
    return SecureApplication(
      nativeRemoveDelay: 800,
      // This callback method will be called when the app become available again
      // and its content was hidden with an overlay. We can provide logic to
      // unlock the content again. Here we can use any auth logic, for example
      // biometrics with the local_auth package.
      onNeedUnlock: (secureApplicationStateNotifier) {
        print(
          'Needs to be unlocked. You can use any auth method, e.g local_auth to unlock the content',
        );
        return null;
      },
      child: _SecureApplicationContent(),
    );
  }
}

class _SecureApplicationContent extends StatefulWidget {
  const _SecureApplicationContent({super.key});

  @override
  State<_SecureApplicationContent> createState() =>
      _SecureApplicationContentState();
}

class _SecureApplicationContentState extends State<_SecureApplicationContent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Enable the feautre. This will add overlay when our app goes background.
    SecureApplicationProvider.of(context)?.secure();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the sensitive part with SecureGate.
    // This will hide the sensitive part until we unlock the content.
    return SecureGate(
      blurr: 60,
      opacity: 0.8,
      // The content of this builder will be displayed after our app
      // comes back to foreground and its content was hidden with the overlay.
      lockedBuilder: (context, secureApplicationController) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Content is locked!'),
            ElevatedButton(
              onPressed: () {
                // Unlock the content manually.
                secureApplicationController?.unlock();
              },
              child: Text('Unlock'),
            ),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          'Your sensitive data',
        ),
      ),
    );
  }
}
