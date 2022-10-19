import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:secure_banking_app/my_secret.dart';

import 'change_secret_dialog.dart';

const _myStorageName = 'mystorage';

/// Displays the conent of the secret storage and provides oprations to
/// change its value.
class BiometricStorageDemo extends StatelessWidget {
  const BiometricStorageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Let's check whether the device supports the biometric storage.
      future: BiometricStorage().canAuthenticate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != CanAuthenticateResponse.success) {
            return const Center(
              child: Text('Can not use biometric storage'),
            );
          }
          // We have the functionality, show the content.
          return _BiometricStorageProvider(
            builder: (secureStorage) => _BiometricStorageDemoPage(
              secureStorage: secureStorage,
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

/// Provides a secure storage through its builder.
class _BiometricStorageProvider extends StatelessWidget {
  const _BiometricStorageProvider({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// Bulder function that provides access to the secure storage.
  final Widget Function(BiometricStorageFile) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: BiometricStorage().getStorage(_myStorageName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return builder(snapshot.data!);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

/// Displats the content of the secure storage and operations to manipulate
/// it.
class _BiometricStorageDemoPage extends StatefulWidget {
  const _BiometricStorageDemoPage({
    super.key,
    required this.secureStorage,
  });

  final BiometricStorageFile secureStorage;

  @override
  State<_BiometricStorageDemoPage> createState() =>
      _BiometricStorageDemoPageState();
}

class _BiometricStorageDemoPageState extends State<_BiometricStorageDemoPage> {
  /// Changes the current secret value by showing an edit dialog
  Future<void> _changeMySecret() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    /// Read the actual value
    final currentSecret = await widget.secureStorage.read();
    // Display a dialog with a text field where the user can change their secret.
    final newSecret = await showDialog(
      context: context,
      builder: (context) => ChangeSecretDialog(
        currentSecret: currentSecret,
      ),
    );
    if (newSecret != null) {
      // Save the secret value in the secure storage.
      await widget.secureStorage.write(newSecret);
      setState(() {});
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Your little secret is updated.',
          ),
        ),
      );
    }
  }

  /// Removes the current value.
  Future<void> _deleteMySecret() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // Deletes a key from the secure storage.
    await widget.secureStorage.delete();
    setState(() {});
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Your little secret is removed.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MySecret(
      readMySecret: widget.secureStorage.read,
      changeMySecret: _changeMySecret,
      deleteMySecret: _deleteMySecret,
    );
  }
}
