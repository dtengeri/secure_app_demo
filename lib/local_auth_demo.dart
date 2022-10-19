import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Displats sensitive information only after the user has authenticed with
/// biometrics.
class LocalAuthDemo extends StatefulWidget {
  const LocalAuthDemo({super.key});

  @override
  State<LocalAuthDemo> createState() => _LocalAuthDemoState();
}

class _LocalAuthDemoState extends State<LocalAuthDemo> {
  final auth = LocalAuthentication();

  /// Check whether the device supports authentication
  Future<bool> _isLocalAuthAvailableOnDevice() async {
    // Check whether the device is capable of using biometrics
    final isSupported = await auth.isDeviceSupported();
    if (!isSupported) {
      return false;
    }
    try {
      // Check whether it is configured on the device.
      return auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isLocalAuthAvailableOnDevice(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!) {
            return _LocalAuthenticator(auth: auth);
          }
          return const Center(
            child: Text(
              'Can not authenticate with biometrics. PLease enable it on your device.',
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

/// Does the authentication and displats the sensitive information based on its
/// result
class _LocalAuthenticator extends StatelessWidget {
  const _LocalAuthenticator({
    super.key,
    required this.auth,
  });

  final LocalAuthentication auth;

  /// Authenticate the user with biometris. The method will be chosen by
  /// the OS.
  Future<bool> _authenticate() => auth.authenticate(
        localizedReason: 'Please auth yourself',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authenticate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!) {
            return const Center(
              child: Text('Welcome! You can see your sensitive data.'),
            );
          }
          return const Center(
            child:
                Text('Sorry, but you are not allowed to access to this page.'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
